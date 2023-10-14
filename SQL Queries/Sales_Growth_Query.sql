Declare @seventhDay Date = 
	(Select 
		DATEADD(DAY, 6,MIN(CAST(s.sales_transaction_date as Date))) 
	from 
		[Electric Veheicle Sales DB].[dbo].[Sales] s
	where 
	s.product_id = 
		(
		select p.product_id
		from [Electric Veheicle Sales DB].[dbo].Products p
		where p.model = 'Sprint'
		)
	)

Select 
	*,
	'Cumm Total 7D_Prev' = CAST(lag(Inner_table.[Cumm Total 7D], 1) over(order by CAST(Inner_table.Transaction_Date as Date)) as float),
	'Growth %' = ((CAST(Inner_table.[Cumm Total 7D] as float) - 
		CAST(lag(Inner_table.[Cumm Total 7D], 1) over(order by CAST(Inner_table.Transaction_Date as Date)) as float))
		/CAST(lag(Inner_table.[Cumm Total 7D], 1) over(order by CAST(Inner_table.Transaction_Date as Date)) as float)) 
		
From 
(
	SELECT 
		Transaction_Date = CAST(s.sales_transaction_date as Date),
		'Unit Sold' = count(*),
		'Cumm Total 7D' = 
		(CASE 
			WHEN CAST(s.sales_transaction_date as Date) >= @seventhDay 
				then SUM(count(*)) OVER(order by CAST(s.sales_transaction_date as Date) ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
			ELSE NULL
			END)
			
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
where Month(Inner_table.Transaction_Date) = 10
and Year(Inner_table.Transaction_Date) = 2016
order by CAST(Inner_table.Transaction_Date as Date)
