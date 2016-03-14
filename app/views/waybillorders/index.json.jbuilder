json.array!(@waybillorders) do |waybillorder|
  json.extract! waybillorder, :id, :orderNum, :googsName1, :googdName2, :goodsName3, :number1, :number2, :number3, :weight1, :weight2, :weight3, :volume1, :volume2, :volume3, :freightCost, :insuranceCost, :packingCost, :deliverCost, :acceptCost, :isTransfer, :transferCost, :transferDestintion, :otherCost, :total, :consignor_id, :consignee_id, :proxycollection, :truck_id, :company_id, :user_id, :paymentmenthod_id, :line_id
  json.url waybillorder_url(waybillorder, format: :json)
end
