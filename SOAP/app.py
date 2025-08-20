from flask import Flask, render_template, request, redirect, url_for, jsonify, session
from flask_pymongo import PyMongo
from bson.objectid import ObjectId
from werkzeug.security import generate_password_hash
from datetime import datetime
import re

app = Flask(__name__)
app.secret_key = "clave_super_secreta"  # Necesaria para sesiones

# Conexión MongoDB
app.config["MONGO_URI"] = "mongodb://localhost:27017/soap_project"
mongo = PyMongo(app)

# =========================
# VALIDACIONES
# =========================
def validar_nombre(nombre):
    return re.match(r"^[A-Za-zÁÉÍÓÚÑáéíóúñ\s]+$", nombre)

def validar_correo(correo):
    return re.match(r"^[\w\.-]+@[\w\.-]+\.\w+$", correo)

def validar_password(password):
    # Mínimo 8 caracteres, 1 mayúscula, 1 número, 1 caracter especial
    return re.match(r"^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$", password)

# =========================
# LOGIN BÁSICO SOLO PARA ADMIN
# =========================
@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        correo = request.form["correo"]
        user = mongo.db.usuarios.find_one({"correo": correo})
        if user and user["rol"] == "Administrador":
            session["admin"] = True
            return redirect(url_for("gestionar"))
        return "Acceso denegado (solo admin)."
    return '''
        <form method="POST">
            <input name="correo" placeholder="Correo de admin" required>
            <button type="submit">Entrar</button>
        </form>
    '''

# =========================
# REGISTRO DE USUARIOS
# =========================
@app.route("/registro", methods=["GET", "POST"])
def registro():
    roles = ["Administrador", "Vendedor", "Consultor"]

    if request.method == "POST":
        nombre = request.form["nombre"]
        correo = request.form["correo"]
        password = request.form["password"]
        rol = request.form["rol"]

        # Validaciones
        if not validar_nombre(nombre):
            return "❌ Nombre inválido (solo letras y espacios)."
        if not validar_correo(correo):
            return "❌ Correo inválido."
        if not validar_password(password):
            return "❌ La contraseña debe tener mínimo 8 caracteres, una mayúscula, un número y un símbolo."
        if mongo.db.usuarios.find_one({"correo": correo}):
            return "❌ El correo ya está registrado."

        password_hash = generate_password_hash(password)

        mongo.db.usuarios.insert_one({
            "nombre": nombre,
            "correo": correo,
            "password": password_hash,
            "rol": rol,
            "activo": True,  # activo por defecto
            "historial_roles": [
                {"rol": rol, "fecha": datetime.now().strftime("%Y-%m-%d %H:%M:%S")}
            ]
        })
        return redirect(url_for("gestionar"))

    return render_template("registro.html", roles=roles)

# =========================
# GESTIONAR USUARIOS
# =========================
@app.route("/gestionar", methods=["GET", "POST"])
def gestionar():
    if not session.get("admin"):
        return "❌ Solo los administradores pueden gestionar usuarios."

    # Filtros por rol y estado
    filtro = {}
    rol_filtro = request.args.get("rol")
    estado_filtro = request.args.get("activo")

    if rol_filtro:
        filtro["rol"] = rol_filtro
    if estado_filtro:
        filtro["activo"] = True if estado_filtro == "1" else False

    usuarios = list(mongo.db.usuarios.find(filtro))
    roles = ["Administrador", "Vendedor", "Consultor"]

    if request.method == "POST":
        user_id = request.form["id"]
        rol = request.form["rol"]
        activo = True if request.form["activo"] == "1" else False

        mongo.db.usuarios.update_one(
            {"_id": ObjectId(user_id)},
            {
                "$set": {"rol": rol, "activo": activo},
                "$push": {"historial_roles": {"rol": rol, "fecha": datetime.now().strftime("%Y-%m-%d %H:%M:%S")}}
            }
        )
        return redirect(url_for("gestionar"))

    return render_template("gestionar.html", usuarios=usuarios, roles=roles)

# =========================
# API REST
# =========================
@app.route("/api/usuarios", methods=["GET"])
def api_usuarios():
    usuarios = list(mongo.db.usuarios.find({}, {"password": 0}))  # ocultamos password
    for u in usuarios:
        u["_id"] = str(u["_id"])
    return jsonify(usuarios)

@app.route("/api/usuarios/<id>", methods=["GET"])
def api_usuario(id):
    user = mongo.db.usuarios.find_one({"_id": ObjectId(id)}, {"password": 0})
    if user:
        user["_id"] = str(user["_id"])
        return jsonify(user)
    return jsonify({"error": "Usuario no encontrado"}), 404

if __name__ == "__main__":
    app.run(debug=True)
