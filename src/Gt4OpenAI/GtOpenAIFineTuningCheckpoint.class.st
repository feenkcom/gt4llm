Class {
	#name : #GtOpenAIFineTuningCheckpoint,
	#superclass : #GtLlmEntity,
	#instVars : [
		'id',
		'createdAt',
		'fineTunedModelCheckpoint',
		'metrics',
		'fineTuningJobId',
		'stepNumber'
	],
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAIFineTuningCheckpoint class >> serializationProperties [
	^ {#id -> #id.
		#created_at -> #createdAt.
		#fine_tuned_model_checkpoint -> #fineTunedModelCheckpoint.
		#metrics -> #metrics.
		#fine_tuning_job_id -> #fineTuningJobId.
		#step_number -> #stepNumber}
]

{ #category : #accessing }
GtOpenAIFineTuningCheckpoint >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtOpenAIFineTuningCheckpoint >> createdAt: anObject [
	createdAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtOpenAIFineTuningCheckpoint >> fineTunedModelCheckpoint [
	^ fineTunedModelCheckpoint
]

{ #category : #accessing }
GtOpenAIFineTuningCheckpoint >> fineTunedModelCheckpoint: anObject [
	fineTunedModelCheckpoint := anObject
]

{ #category : #accessing }
GtOpenAIFineTuningCheckpoint >> fineTuningJobId [
	^ fineTuningJobId
]

{ #category : #accessing }
GtOpenAIFineTuningCheckpoint >> fineTuningJobId: anObject [
	fineTuningJobId := anObject
]

{ #category : #accessing }
GtOpenAIFineTuningCheckpoint >> id [
	^ id
]

{ #category : #accessing }
GtOpenAIFineTuningCheckpoint >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtOpenAIFineTuningCheckpoint >> metrics [
	^ metrics
]

{ #category : #accessing }
GtOpenAIFineTuningCheckpoint >> metrics: anObject [
	metrics := anObject
]

{ #category : #accessing }
GtOpenAIFineTuningCheckpoint >> stepNumber [
	^ stepNumber
]

{ #category : #accessing }
GtOpenAIFineTuningCheckpoint >> stepNumber: anObject [
	stepNumber := anObject
]
