Declare @sprintLaunchDate Date = 
(
Select p.production_start_date
from [Electric Veheicle Sales DB].dbo.Products p
where p.model = 'Sprint'
)

select 
	Email_Sent = count(e.email_id),
	Clicked = sum(cast(e.clicked as decimal)),
	Opened = sum(cast(e.opened as decimal)),
	Bounced = sum(cast(e.bounced as decimal)),
	Open_Rate = sum(cast(e.opened as decimal))/count(e.email_id),
	Click_Rate = sum(cast(e.clicked as decimal)) / (count(e.email_id) - sum(cast(e.bounced as decimal)))
from
	[Electric Veheicle Sales DB].dbo.emails e
where 
	e.email_subject_id = 
		(
		select
			es.email_subject_id
		from
			[Electric Veheicle Sales DB].dbo.email_subject es
		where es.email_subject like '%Sprint%'
		)
and Cast(e.sent_date as Date) between DATEADD(month, -2, @sprintLaunchDate) and @sprintLaunchDate
