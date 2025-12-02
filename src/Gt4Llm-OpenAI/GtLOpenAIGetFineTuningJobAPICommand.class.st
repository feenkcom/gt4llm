Class {
	#name : #GtLOpenAIGetFineTuningJobAPICommand,
	#superclass : #GtLAPICommand,
	#instVars : [
		'job'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIGetFineTuningJobAPICommand >> job [
	^ job
]

{ #category : #accessing }
GtLOpenAIGetFineTuningJobAPICommand >> job: anObject [
	job := anObject
]

{ #category : #accessing }
GtLOpenAIGetFineTuningJobAPICommand >> request [
	^ self client get: '/fine_tuning/jobs/' , self job
]

{ #category : #accessing }
GtLOpenAIGetFineTuningJobAPICommand >> serializationClass [
	^ GtLOpenAIFineTuningJob
]
