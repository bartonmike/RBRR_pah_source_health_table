Declare @Table TABLE (
	IdentityID int IDENTITY(1,1), 
	ParameterID int, 
	ParameterName varchar(max))

Declare @ResultsTable TABLE (
	IdentityID int IDENTITY(1,1), 
	STIID int,
	SampleNum varchar(24),
	RunNumber int,
	ParameterID int, 
	ParameterName varchar(max),
	results float,
	rawResults varchar(max)
	)

	INSERT INTO @Table
		select distinct
		MP.ParameterID,
		ParameterName = case when MP.ParameterName like '%mol%' then left(mp.ParameterName,len(mp.ParameterName) - 6)
		else mp.ParameterName
		end
		

		from WPPhaseResult WP
		
		inner join MasterParameter MP on MP.ParameterID=WP.ParameterID
		inner join STIPhaseStatus STIP on STIP.STIPhaseStatusID=WP.WPPRAppliesToID
		inner join SampleTestInstance STI on STI.STIID=STIP.STIID
		Inner Join TestTemplate T on STI.TestTempID=T.TestTempID
		inner join sample S on S.SampleID=STI.SampleID
		inner join Project P on P.ProjectID=S.ProjectID

		where WP.wpprappliestodesc=0 
		and WP.WPPRReport=1 
		AND (STI.WDTransitionState='Complete' OR STI.WDTransitionState='Batch Review')
		


order by 
ParameterName, MP.ParameterID








insert into @ResultsTable
	
	select distinct
		1 as STIID,
		'1' as SampleNumber,
		1 as RunNumber
		, MP.ParameterID
		,ParameterName = case when MP.ParameterName like '%mol%' then left(mp.ParameterName,len(mp.ParameterName) - 6)
		else mp.ParameterName
		end
		, 1 as conc,
		1 as SWPPRCorrectedCalc
	
		from WPPhaseResult WP
		
		inner join MasterParameter MP on MP.ParameterID=WP.ParameterID
		inner join STIPhaseStatus STIP on STIP.STIPhaseStatusID=WP.WPPRAppliesToID
		inner join SampleTestInstance STI on STI.STIID=STIP.STIID
		Inner Join TestTemplate T on STI.TestTempID=T.TestTempID

		inner join sample S on S.SampleID=STI.SampleID
		inner join Project P on P.ProjectID=S.ProjectID
		left outer join @Table Tab on Tab.ParameterID=MP.ParameterID

			
		where WP.wpprappliestodesc=0 and
		 WP.WPPRReport=1 
		AND (STI.WDTransitionState='Complete' OR STI.WDTransitionState='Batch Review')
		and WP.SWPPRCorrectedCalc not in ('BLOD')
		and WP.WPPRResultQualifier not in ('U')



------------------------------------------------------------------------------------------------------------



		select
			distinct
			MP.ParameterID,
			ParameterNameEnglish = Pahs1.ParameterNameEnglish,
			ParameterNameSpanish = Pahs1.ParameterNameSpanish,
			PetroleumProducts = Pahs1.PetroleumProducts,
			DieselFuels = Pahs1.DieselFuels,
			VehicleExhaust = Pahs1.VehicleExhaust,
			WildfireSmoke = Pahs1.WildfireSmoke,
			Cigarettes = Pahs1.Cigarettes,
			GrilledFood = Pahs1.GrilledFood,
			HealthConcernsEnglish = Pahs1.HealthConcernsEnglish,
			HealthConcernsSpanish = Pahs1.HealthConcernsSpanish,
			ParamCountInResuts = (select count(results) from @ResultsTable RT where RT.ParameterID=MP.ParameteriD),
			1 as ParamSampleCount

	
		from WPPhaseResult WP
		
		inner join MasterParameter MP on MP.ParameterID=WP.ParameterID
		inner join STIPhaseStatus STIP on STIP.STIPhaseStatusID=WP.WPPRAppliesToID
		inner join SampleTestInstance STI on STI.STIID=STIP.STIID
		Inner Join TestTemplate T on STI.TestTempID=T.TestTempID

		inner join sample S on S.SampleID=STI.SampleID
		inner join Project P on P.ProjectID=S.ProjectID
		left outer join @Table Tab on Tab.ParameterID=MP.ParameterID
		join Custom_OSU_27PriorityPahsEnglish Pahs1 on Pahs1.MolParameterID = MP.parameterID

		where WP.wpprappliestodesc=0 and
		 WP.WPPRReport=1
		AND (STI.WDTransitionState='Complete' OR STI.WDTransitionState='Batch Review')

		and WP.SWPPRCorrectedCalc not in ('BLOD')
		and WP.WPPRResultQualifier not in ('U')
	

		and (Pahs1.PriorityATSDR = 1 or Pahs1.PriorityEPA = 1)
order by ParameterNameEnglish
