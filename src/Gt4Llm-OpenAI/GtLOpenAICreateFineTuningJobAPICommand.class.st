Class {
	#name : #GtLOpenAICreateFineTuningJobAPICommand,
	#superclass : #GtLAPICommand,
	#instVars : [
		'model',
		'file'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAICreateFineTuningJobAPICommand >> file [
	^ file
]

{ #category : #accessing }
GtLOpenAICreateFineTuningJobAPICommand >> file: anObject [
	file := anObject
]

{ #category : #accessing }
GtLOpenAICreateFineTuningJobAPICommand >> model [
	^ model
]

{ #category : #accessing }
GtLOpenAICreateFineTuningJobAPICommand >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtLOpenAICreateFineTuningJobAPICommand >> request [
	^ self client
		post: 'fine_tuning/jobs'
		withEntity: {'training_file' -> self file.
				'model' -> self model} asDictionary
]

{ #category : #accessing }
GtLOpenAICreateFineTuningJobAPICommand >> serializationClass [
	^ GtLOpenAIFineTuningJob
]
