<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model {
    use HasFactory;

    protected $fillable = [
        'name','description','is_antibiotic','requires_prescription',
        'cost_price','sale_price','stock','expiration_date','sku',
        'barcode','brand','category','presentation'
    ];

    protected $casts = [
        'is_antibiotic' => 'boolean',
        'requires_prescription' => 'boolean',
        'expiration_date' => 'date',
        'cost_price' => 'decimal:2',
        'sale_price' => 'decimal:2',
    ];
}
