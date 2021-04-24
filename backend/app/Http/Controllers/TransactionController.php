<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Transaction;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;

class TransactionController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $transaction = Transaction::all();
        return response()->json([
            'message' => 'Successfully return list of transaction',
            'data' => $transaction
        ], 200);
    }

    public function store(Request $request)
    {
        $request->validate([
            "products_id" => "required|integer",
            "count" => "required|integer",
            "price" => "required|integer",
            "sell_at" => "required|date",
        ]);

        $transaction = new Transaction([
            "products_id" => $request->products_id,
            "count" => $request->count,
            "price" => $request->price,
            "sell_at" => $request->sell_at
        ]);

        $transaction->save();

        return response()->json([
            "message" => "Successfully insert a transaction",
            "data" => $transaction
        ], 200);
    }

    public function show($id)
    {
        $transaction = Transaction::find($id);
        if(is_null($transaction)) {
            return response()->json([
                'message' => 'Error transaction not found',
            ]);
        }

        return response()->json([
            'message' => 'Successfully retrieve a transaction',
            'data' => $transaction,
        ], 200);
    }


    public function update(Request $request, $id)
    {
        $transaction = Transaction::find($id);

        $request->validate([
            "products_id" => 'required|integer',
            "sell_at" => 'required|date',
            "count" => 'required|integer',
            "price" => 'required|integer'
        ]);

        $transaction->sell_at = $request->sell_at;
        $transaction->products_id = $request->products_id;
        $transaction->count = $request->count;
        $transaction->price = $request->price;

        $transaction->save();

        return response()->json([
            'message' => 'Successfully update a products',
            'data' => $transaction
        ], 201);
    }

    public function destroy($id)
    {
        $transaction = Transaction::find($id);
        if(is_null($transaction)) {
            return response()->json([
                'message' => 'Error transaction not found',
            ]);
        }

        $transaction->delete();

        return response()->json([
            'message' => 'Successfully delete a transaction',
        ], 200);
    }

    public function getWeekChart() {
        $today = Carbon::now();
        $startWeek = $today->startOfWeek()->format('Y-m-d');
        $data = [];
        $data['weekNumber'] = $today->weekOfMonth;
        for($i = 0; $i < 7; $i++) {
            $day = $today->startOfWeek()->addDay($i)->format('Y-m-d');
            $transaction = DB::table('transactions')
                           ->where('sell_at', $day)
                           ->sum('price');
            $data["totalTransaction"][$i] = (double) $transaction;
        }
        $maxValue = $data["totalTransaction"];
        sort($maxValue);
        $data["maxValue"] = (double) $maxValue[6];
        return response()->json([
            'message' => 'Successfully delete a transaction',
            'data' => $data
        ], 200);
    }
}
