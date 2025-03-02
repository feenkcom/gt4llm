Class {
	#name : #GtOpenAIGetFineTuningJobAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'job'
	],
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAIGetFineTuningJobAPIClient >> job [
	^ job
]

{ #category : #accessing }
GtOpenAIGetFineTuningJobAPIClient >> job: anObject [
	job := anObject
]

{ #category : #accessing }
GtOpenAIGetFineTuningJobAPIClient >> request [
	^ self client get: '/fine_tuning/jobs/' , self job
]

{ #category : #accessing }
GtOpenAIGetFineTuningJobAPIClient >> serializationClass [
	^ GtOpenAIFineTuningJob
]
