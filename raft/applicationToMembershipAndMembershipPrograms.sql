use raftdb2den;

select *, 
	Membership.StartDate, 
	Membership.ExpireDate, 
	Membership.Initials, 
	Membership.Payment,
	MembershipPrograms.ProgramName,
	MembershipPrograms.Description from application
left join MembershipPrograms on application.ProgramId = MembershipPrograms.ProgramId
left join Membership on application.MembershipID = Membership.MembershipID