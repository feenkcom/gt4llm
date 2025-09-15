Class {
	#name : #GtOpenAIFineTuningJob,
	#superclass : #GtLlmEntity,
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
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAIFineTuningJob class >> leJsonV4Name [

	^ #gtOpenAIFineTuningJob
]

{ #category : #accessing }
GtOpenAIFineTuningJob class >> serializationProperties [
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
GtOpenAIFineTuningJob >> checkpoints [
	^ self client getFineTuningCheckpointsForJob: self id
]

{ #category : #accessing }
GtOpenAIFineTuningJob >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtOpenAIFineTuningJob >> createdAt: anObject [
	createdAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtOpenAIFineTuningJob >> currentTrainingTime [
	^ self totalTrainingTime
		ifNil: [ ^ DateAndTime now - (DateAndTime fromUnixTime: self createdAt) ]
]

{ #category : #accessing }
GtOpenAIFineTuningJob >> estimatedFinish [
	^ estimatedFinish
]

{ #category : #accessing }
GtOpenAIFineTuningJob >> estimatedFinish: anObject [
	estimatedFinish := self deserializeTime: anObject
]

{ #category : #accessing }
GtOpenAIFineTuningJob >> events [
	^ self client getFineTuningEventsForJob: self id
]

{ #category : #accessing }
GtOpenAIFineTuningJob >> fineTunedModel [
	^ fineTunedModel
]

{ #category : #accessing }
GtOpenAIFineTuningJob >> fineTunedModel: anObject [
	fineTunedModel := anObject
]

{ #category : #accessing }
GtOpenAIFineTuningJob >> finishedAt [
	^ finishedAt
]

{ #category : #accessing }
GtOpenAIFineTuningJob >> finishedAt: anObject [
	finishedAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtOpenAIFineTuningJob >> gtActionChatFor: anAction [
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
GtOpenAIFineTuningJob >> gtCheckpointsFor: aView [
	<gtView>
	^ aView forward
		title: 'Checkpoints';
		priority: 2;
		object: [ self checkpoints ];
		view: #gtCheckpointsFor:
]

{ #category : #accessing }
GtOpenAIFineTuningJob >> gtEventsFor: aView [
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

{ #category : #accessing }
GtOpenAIFineTuningJob >> id [
	^ id
]

{ #category : #accessing }
GtOpenAIFineTuningJob >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtOpenAIFineTuningJob >> model [
	^ model
]

{ #category : #accessing }
GtOpenAIFineTuningJob >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtOpenAIFineTuningJob >> object [
	^ object
]

{ #category : #accessing }
GtOpenAIFineTuningJob >> object: anObject [
	object := anObject
]

{ #category : #accessing }
GtOpenAIFineTuningJob >> organizationId [
	^ organizationId
]

{ #category : #accessing }
GtOpenAIFineTuningJob >> organizationId: anObject [
	organizationId := anObject
]

{ #category : #'as yet unclassified' }
GtOpenAIFineTuningJob >> refresh [
	self from: (client getFineTuningJob: self id) serialize
]

{ #category : #accessing }
GtOpenAIFineTuningJob >> resultFiles [
	^ resultFiles
]

{ #category : #accessing }
GtOpenAIFineTuningJob >> resultFiles: anObject [
	resultFiles := anObject
]

{ #category : #accessing }
GtOpenAIFineTuningJob >> status [
	^ status
]

{ #category : #accessing }
GtOpenAIFineTuningJob >> status: anObject [
	status := anObject
]

{ #category : #accessing }
GtOpenAIFineTuningJob >> totalTrainingTime [
	^ self finishedAt
		ifNil: [ nil ]
		ifNotNil: [ (DateAndTime fromUnixTime: self finishedAt)
				- (DateAndTime fromUnixTime: self createdAt) ]
]

{ #category : #accessing }
GtOpenAIFineTuningJob >> trainingFile [
	^ trainingFile
]

{ #category : #accessing }
GtOpenAIFineTuningJob >> trainingFile: anObject [
	trainingFile := anObject
]

{ #category : #accessing }
GtOpenAIFineTuningJob >> validationFile [
	^ validationFile
]

{ #category : #accessing }
GtOpenAIFineTuningJob >> validationFile: anObject [
	validationFile := anObject
]
