<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class ProductRequest extends FormRequest {
    public function authorize(): bool { return true; }

    public function rules(): array {
        $id = $this->route('product')?->id;

        return [
            'name' => ['required','string','max:150'],
            'description' => ['nullable','string'],
            'is_antibiotic' => ['required','boolean'],
            'requires_prescription' => ['required','boolean'],
            'cost_price' => ['required','numeric','min:0'],
            'sale_price' => ['required','numeric','gte:cost_price'],
            'stock' => ['required','integer','min:0'],
            'expiration_date' => ['nullable','date'],
            'sku' => ['required','string','max:32','unique:products,sku,'.($id ?? 'NULL').',id'],
            'barcode' => ['nullable','string','max:20','unique:products,barcode,'.($id ?? 'NULL').',id'],
            'brand' => ['nullable','string','max:80'],
            'category' => ['nullable','string','max:50'],
            'presentation' => ['nullable','string','max:60'],
        ];
    }
}
