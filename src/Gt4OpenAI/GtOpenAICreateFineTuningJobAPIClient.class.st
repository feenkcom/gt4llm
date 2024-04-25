Class {
	#name : #GtOpenAICreateFineTuningJobAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'model',
		'file'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
GtOpenAICreateFineTuningJobAPIClient >> file [
	^ file
]

{ #category : #accessing }
GtOpenAICreateFineTuningJobAPIClient >> file: anObject [
	file := anObject
]

{ #category : #accessing }
GtOpenAICreateFineTuningJobAPIClient >> model [
	^ model
]

{ #category : #accessing }
GtOpenAICreateFineTuningJobAPIClient >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtOpenAICreateFineTuningJobAPIClient >> request [
	^ self client
		post: 'fine_tuning/jobs'
		withEntity: {'training_file' -> self file.
				'model' -> self model} asDictionary
]

{ #category : #accessing }
GtOpenAICreateFineTuningJobAPIClient >> serializationClass [
	^ GtOpenAIFineTuningJob
]
