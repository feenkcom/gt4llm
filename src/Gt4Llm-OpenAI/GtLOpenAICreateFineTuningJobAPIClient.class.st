Class {
	#name : #GtLOpenAICreateFineTuningJobAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'model',
		'file'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAICreateFineTuningJobAPIClient >> file [
	^ file
]

{ #category : #accessing }
GtLOpenAICreateFineTuningJobAPIClient >> file: anObject [
	file := anObject
]

{ #category : #accessing }
GtLOpenAICreateFineTuningJobAPIClient >> model [
	^ model
]

{ #category : #accessing }
GtLOpenAICreateFineTuningJobAPIClient >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtLOpenAICreateFineTuningJobAPIClient >> request [
	^ self client
		post: 'fine_tuning/jobs'
		withEntity: {'training_file' -> self file.
				'model' -> self model} asDictionary
]

{ #category : #accessing }
GtLOpenAICreateFineTuningJobAPIClient >> serializationClass [
	^ GtLOpenAIFineTuningJob
]
