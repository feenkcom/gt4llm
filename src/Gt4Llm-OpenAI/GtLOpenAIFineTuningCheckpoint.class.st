Class {
	#name : #GtLOpenAIFineTuningCheckpoint,
	#superclass : #GtLEntity,
	#instVars : [
		'id',
		'createdAt',
		'fineTunedModelCheckpoint',
		'metrics',
		'fineTuningJobId',
		'stepNumber'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIFineTuningCheckpoint class >> leJsonV4Name [

	^ #gtOpenAIFineTuningCheckpoint
]

{ #category : #accessing }
GtLOpenAIFineTuningCheckpoint class >> serializationProperties [
	^ {#id -> #id.
		#created_at -> #createdAt.
		#fine_tuned_model_checkpoint -> #fineTunedModelCheckpoint.
		#metrics -> #metrics.
		#fine_tuning_job_id -> #fineTuningJobId.
		#step_number -> #stepNumber}
]

{ #category : #accessing }
GtLOpenAIFineTuningCheckpoint >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtLOpenAIFineTuningCheckpoint >> createdAt: anObject [
	createdAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtLOpenAIFineTuningCheckpoint >> fineTunedModelCheckpoint [
	^ fineTunedModelCheckpoint
]

{ #category : #accessing }
GtLOpenAIFineTuningCheckpoint >> fineTunedModelCheckpoint: anObject [
	fineTunedModelCheckpoint := anObject
]

{ #category : #accessing }
GtLOpenAIFineTuningCheckpoint >> fineTuningJobId [
	^ fineTuningJobId
]

{ #category : #accessing }
GtLOpenAIFineTuningCheckpoint >> fineTuningJobId: anObject [
	fineTuningJobId := anObject
]

{ #category : #accessing }
GtLOpenAIFineTuningCheckpoint >> id [
	^ id
]

{ #category : #accessing }
GtLOpenAIFineTuningCheckpoint >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtLOpenAIFineTuningCheckpoint >> metrics [
	^ metrics
]

{ #category : #accessing }
GtLOpenAIFineTuningCheckpoint >> metrics: anObject [
	metrics := anObject
]

{ #category : #accessing }
GtLOpenAIFineTuningCheckpoint >> stepNumber [
	^ stepNumber
]

{ #category : #accessing }
GtLOpenAIFineTuningCheckpoint >> stepNumber: anObject [
	stepNumber := anObject
]
