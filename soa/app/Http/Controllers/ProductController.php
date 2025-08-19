<?php

namespace App\Http\Controllers;

use App\Http\Requests\ProductRequest;
use App\Http\Resources\ProductResource;
use App\Models\Product;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    // GET /api/products
public function index(Request $request)
{
    $q = Product::query();

    // Filtros
    if ($s = $request->string('search')->toString()) {
        $q->where(function($w) use ($s) {
            $w->where('name','like',"%$s%")
              ->orWhere('description','like',"%$s%")
              ->orWhere('sku','like',"%$s%")
              ->orWhere('barcode','like',"%$s%");
        });
    }
    if ($cat = $request->string('category')->toString()) {
        $q->where('category', $cat);
    }
    if (!is_null($request->query('is_antibiotic'))) {
        $q->where('is_antibiotic', filter_var($request->query('is_antibiotic'), FILTER_VALIDATE_BOOLEAN));
    }
    if (!is_null($request->query('requires_prescription'))) {
        $q->where('requires_prescription', filter_var($request->query('requires_prescription'), FILTER_VALIDATE_BOOLEAN));
    }
    if ($min = $request->query('min_price')) {
        $q->where('sale_price','>=', (float)$min);
    }
    if ($max = $request->query('max_price')) {
        $q->where('sale_price','<=', (float)$max);
    }
    if ($exp_before = $request->query('expires_before')) {
        $q->whereDate('expiration_date','<=', $exp_before);
    }

    // Orden
    $sort = $request->query('sort','name');
    $dir  = $request->query('dir','asc');
    if (in_array($sort, ['name','sale_price','stock','expiration_date','created_at'])) {
        $q->orderBy($sort, $dir === 'desc' ? 'desc' : 'asc');
    }

    // Devuelve todos los productos sin paginación
    $products = $q->get();

    return ProductResource::collection($products);
}


    // POST /api/products
    public function store(ProductRequest $request)
    {
        $product = Product::create($request->validated());
        return (new ProductResource($product))->response()->setStatusCode(201);
    }

    // GET /api/products/{product}
    public function show(Product $product)
    {
        return new ProductResource($product);
    }

    // PUT/PATCH /api/products/{product}
    public function update(ProductRequest $request, Product $product)
    {
        $product->update($request->validated());
        return new ProductResource($product);
    }

    // DELETE /api/products/{product}
    public function destroy(Product $product)
    {
        $product->delete();
        return response()->noContent();
    }
}
