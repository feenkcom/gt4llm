Class {
	#name : #GtLOpenAIGetFineTuningJobAPIClient,
	#superclass : #GtLAPICommand,
	#instVars : [
		'job'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIGetFineTuningJobAPIClient >> job [
	^ job
]

{ #category : #accessing }
GtLOpenAIGetFineTuningJobAPIClient >> job: anObject [
	job := anObject
]

{ #category : #accessing }
GtLOpenAIGetFineTuningJobAPIClient >> request [
	^ self client get: '/fine_tuning/jobs/' , self job
]

{ #category : #accessing }
GtLOpenAIGetFineTuningJobAPIClient >> serializationClass [
	^ GtLOpenAIFineTuningJob
]
