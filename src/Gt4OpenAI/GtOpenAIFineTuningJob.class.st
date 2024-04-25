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
		'trainingFile'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
GtOpenAIFineTuningJob class >> serializationProperties [
	^ {#object -> #object.
		#id -> #id.
		#model -> #model.
		#created_at -> #createdAt.
		#fine_tuned_model -> #fineTunedModel.
		#organization_id -> #organizationId.
		#result_files -> #resultFiles.
		#status -> #status.
		#validation_file -> #validationFile.
		#training_file -> #trainingFile}
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
	createdAt := anObject
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
	^ aView forward
		title: 'Events';
		priority: 1;
		object: [ self events ];
		view: #gtEventsFor:
]

{ #category : #accessing }
GtOpenAIFineTuningJob >> gtViewLossFor: aView [
	<gtView>
	^ aView explicit
		title: 'Training loss';
		priority: 3;
		stencil: [ (GtHorizontalSparklineStencil new
				values: ((self events reversed select: [ :anEvent | anEvent data isEmptyOrNil not ])
						withIndexCollect: [ :aValue :i | (aValue data at: 'train_loss') -> i ]);
				color: BrGlamorousColors hoveredButtonTextColor) asElement height: 100 ]
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
