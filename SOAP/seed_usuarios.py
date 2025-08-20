from pymongo import MongoClient
from werkzeug.security import generate_password_hash
from datetime import datetime

# Conexión a MongoDB
client = MongoClient("mongodb://localhost:27017")
db = client.soap_project
usuarios = db.usuarios

# Limpiar colección (opcional)
# usuarios.delete_many({})

# Usuarios de prueba
usuarios_prueba = [
    {
        "nombre": "Admin Principal",
        "correo": "admin@correo.com",
        "password": generate_password_hash("Admin123!"),  # contraseña segura
        "rol": "Administrador",
        "activo": True,
        "historial_roles": [
            {"rol": "Administrador", "fecha": datetime.now().strftime("%Y-%m-%d %H:%M:%S")}
        ]
    },
    {
        "nombre": "Vendedor 1",
        "correo": "vendedor@correo.com",
        "password": generate_password_hash("Vendedor123!"),
        "rol": "Vendedor",
        "activo": True,
        "historial_roles": [
            {"rol": "Vendedor", "fecha": datetime.now().strftime("%Y-%m-%d %H:%M:%S")}
        ]
    },
    {
        "nombre": "Consultor 1",
        "correo": "consultor@correo.com",
        "password": generate_password_hash("Consultor123!"),
        "rol": "Consultor",
        "activo": True,
        "historial_roles": [
            {"rol": "Consultor", "fecha": datetime.now().strftime("%Y-%m-%d %H:%M:%S")}
        ]
    }
]

# Insertar usuarios en la colección
for u in usuarios_prueba:
    if not usuarios.find_one({"correo": u["correo"]}):
        usuarios.insert_one(u)

print("✅ Usuarios de prueba creados correctamente.")
