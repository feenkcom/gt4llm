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
GtOpenAIFineTuningJob >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtOpenAIFineTuningJob >> createdAt: anObject [
	createdAt := anObject
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
