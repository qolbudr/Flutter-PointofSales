<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Products;

class ProductsController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $products = Products::all();
        return response()->json([
            'message' => 'Successfully return list of products',
            'data' => $products,
        ]);

    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $request->validate([
            "products_id" => 'required|integer',
            "name" => 'required|string',
            "count" => 'required|integer',
            "price" => 'required|integer'
        ]);

        $products = new Products([
            "name" => $request->name,
            "count" => $request->count,
            "price" => $request->price,
            "products_id" => $request->products_id
        ]);

        $products->save();

        return response()->json([
            'message' => 'Successfully insert a products',
            'data' => $products
        ]);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $products = Products::find($id);

        if(is_null($products)) {
            return response()->json([
                'message' => 'Error products not found',
            ]);
        }

        return response()->json([
            'message' => 'Successfully retrieve a products',
            'data' => $products,
        ]);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        $products = Products::find($id);

        $request->validate([
            "products_id" => 'required|integer',
            "name" => 'required|string',
            "count" => 'required|integer',
            "price" => 'required|integer'
        ]);

        $products->name = $request->name;
        $products->products_id = $request->products_id;
        $products->count = $request->count;
        $products->price = $request->price;

        $products->save();

        return response()->json([
            'message' => 'Successfully update a products',
            'data' => $products
        ], 200);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $products = Products::find($id);

        if(is_null($products)) {
            return response()->json([
                'message' => 'Error products not found',
            ]);
        }

        $products->delete();

        return response()->json([
            'message' => 'Successfully delete a products'
        ]);
    }
}
