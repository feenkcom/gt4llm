Class {
	#name : #GtLOpenAIFineTuningJob,
	#superclass : #GtLEntity,
	#instVars : [
		'object',
		'id',
		'model',
		'createdAt',
		'fineTunedModel',
		'organizationId',
		'resultFiles',
		'status',
		'validationFile',
		'trainingFile',
		'finishedAt',
		'estimatedFinish'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIFineTuningJob class >> leJsonV4Name [

	^ #gtOpenAIFineTuningJob
]

{ #category : #accessing }
GtLOpenAIFineTuningJob class >> serializationProperties [
	^ {#object -> #object.
		#id -> #id.
		#model -> #model.
		#created_at -> #createdAt.
		#finished_at -> #finishedAt.
		#fine_tuned_model -> #fineTunedModel.
		#organization_id -> #organizationId.
		#result_files -> #resultFiles.
		#status -> #status.
		#validation_file -> #validationFile.
		#training_file -> #trainingFile.
		#estimated_finish -> #estimatedFinish}
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> checkpoints [
	^ self client getFineTuningCheckpointsForJob: self id
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> createdAt: anObject [
	createdAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> currentTrainingTime [
	^ self totalTrainingTime
		ifNil: [ ^ DateAndTime now - (DateAndTime fromUnixTime: self createdAt) ]
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> estimatedFinish [
	^ estimatedFinish
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> estimatedFinish: anObject [
	estimatedFinish := self deserializeTime: anObject
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> events [
	^ self client getFineTuningEventsForJob: self id
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> fineTunedModel [
	^ fineTunedModel
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> fineTunedModel: anObject [
	fineTunedModel := anObject
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> finishedAt [
	^ finishedAt
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> finishedAt: anObject [
	finishedAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> gtActionChatFor: anAction [
	<gtAction>
	self fineTunedModel ifNil: [ ^ anAction noAction ].

	^ anAction button
		label: 'Chat';
		priority: 1;
		action: [ :aButton | 
			aButton phlow
				spawnObject: (GtLlmChat new
						provider: (GtOpenAIProvider withApiKeyFromFile model: self fineTunedModel)) ]
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> gtCheckpointsFor: aView [
	<gtView>
	^ aView forward
		title: 'Checkpoints';
		priority: 2;
		object: [ self checkpoints ];
		view: #gtCheckpointsFor:
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> gtEventsFor: aView [
	<gtView>
	"cannot be forward due to update button"
	^ aView columnedList
		title: 'Events';
		priority: 1;
		items: [ self events ];
		column: 'Level' text: #level weight: 0.5;
		column: 'Message' text: #message weight: 2;
		column: 'Time' text: #createdAt weight: 0.5;
		actionUpdateButton
]

{ #category : #'gt - extensions' }
GtLOpenAIFineTuningJob >> gtUpdateActionFor: anAction [
	<gtAction>
	self client ifNil: [ ^ anAction noAction ].

	^ anAction button
		priority: 1;
		tooltip: 'Update job';
		icon: BrGlamorousVectorIcons refresh;
		action: [ :aButton | aButton phlow spawnObject: (self refresh) ]
]

{ #category : #'gt - extensions' }
GtLOpenAIFineTuningJob >> gtViewLossFor: aView [
	<gtView>
	^ aView explicit
		title: 'Training loss';
		priority: 4;
		stencil: [ | aData aChart |
			aData := GtPlotterDataGroup new
					values: ((self events reversed select: [ :anEvent | anEvent data isEmptyOrNil not ])
							collectWithIndex: [ :anEvent :anIndex | anIndex -> (anEvent data at: 'train_loss') ]);
					background: BrGlamorousColors primaryBorderColor.
			aChart := GtPlotterLineChart new.
			aChart with: aData.
			aChart valueX: #key.
			aChart scaleX: GtPlotterLinearScale new.
			aChart labelFormatX: [ :x | x asString ].
			aChart valueY: #value.
			aChart scaleY: GtPlotterLinearScale new.
			aChart labelFormatY: [ :x | x printShowingDecimalPlaces: 1 ].
			aChart ticksY: 4.
			aChart asElement height: 300 ];
		actionUpdateButton
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> id [
	^ id
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> model [
	^ model
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> object [
	^ object
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> object: anObject [
	object := anObject
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> organizationId [
	^ organizationId
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> organizationId: anObject [
	organizationId := anObject
]

{ #category : #'as yet unclassified' }
GtLOpenAIFineTuningJob >> refresh [
	self from: (client getFineTuningJob: self id) serialize
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> resultFiles [
	^ resultFiles
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> resultFiles: anObject [
	resultFiles := anObject
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> status [
	^ status
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> status: anObject [
	status := anObject
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> totalTrainingTime [
	^ self finishedAt
		ifNil: [ nil ]
		ifNotNil: [ (DateAndTime fromUnixTime: self finishedAt)
				- (DateAndTime fromUnixTime: self createdAt) ]
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> trainingFile [
	^ trainingFile
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> trainingFile: anObject [
	trainingFile := anObject
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> validationFile [
	^ validationFile
]

{ #category : #accessing }
GtLOpenAIFineTuningJob >> validationFile: anObject [
	validationFile := anObject
]
