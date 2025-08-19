<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class ProductResource extends JsonResource {
    public function toArray($request): array {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'description' => $this->description,
            'is_antibiotic' => $this->is_antibiotic,
            'requires_prescription' => $this->requires_prescription,
            'cost_price' => (float) $this->cost_price,
            'sale_price' => (float) $this->sale_price,
            'stock' => $this->stock,
            'expiration_date' => optional($this->expiration_date)->toDateString(),
            'sku' => $this->sku,
            'barcode' => $this->barcode,
            'brand' => $this->brand,
            'category' => $this->category,
            'presentation' => $this->presentation,
            'created_at' => $this->created_at?->toISOString(),
            'updated_at' => $this->updated_at?->toISOString(),
        ];
    }
}
