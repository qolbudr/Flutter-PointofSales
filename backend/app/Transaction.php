<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Transaction extends Model
{
	protected $fillable = [
		'products_id', 'count', 'price', 'sell_at'
	];
}
