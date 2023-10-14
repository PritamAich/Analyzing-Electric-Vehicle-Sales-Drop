SELECT 
	Outer_table.Transaction_Date,
	Outer_table.[Sprint Unit Sold],
	Outer_table.[Growth %]
FROM
(
	Select 
		*,
		'Growth %' = ((CAST(Inner_table.[Sprint Unit Sold] as float) - 
			CAST(lag(Inner_table.[Sprint Unit Sold], 1) over(order by CAST(Inner_table.Transaction_Date as Date)) as float))
			/CAST(lag(Inner_table.[Sprint Unit Sold], 1) over(order by CAST(Inner_table.Transaction_Date as Date)) as float)),
		Index# = ROW_NUMBER() over(order by Inner_table.Transaction_Date)
		
	From 
	(
		SELECT 
			Transaction_Date = CAST(s.sales_transaction_date as Date),
			'Sprint Unit Sold' = count(*)
			
		FROM
			[Electric Veheicle Sales DB].[dbo].[Sales] s
		where 
			s.product_id = 
				(
				select p.product_id
				from [Electric Veheicle Sales DB].[dbo].Products p
				where p.model = 'Sprint'
				)
		group by CAST(s.sales_transaction_date as Date)
	
	) as Inner_table
	
) Outer_table
where Outer_table.Index# <= 21
order by CAST(Outer_table.Transaction_Date as Date)