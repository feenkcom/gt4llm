Class {
	#name : #GtOllamaGtTutor,
	#superclass : #GtLlmGtSpecificTutor,
	#instVars : [
		'internalModel'
	],
	#category : #'Gt4Ollama-Tutor'
}

{ #category : #accessing }
GtOllamaGtTutor >> addChat [
	| aChat |
	aChat := GtLlmChat new
			context: pipelineBuilder value;
			provider: (GtOllamaProvider new model: self internalModel).
	chats add: aChat.

	^ aChat
]

{ #category : #accessing }
GtOllamaGtTutor >> defaultModel [
	^ 'llama3.1'
]

{ #category : #accessing }
GtOllamaGtTutor >> ensureModel [
	| internalModelName modelFile |
	internalModelName := 'gt-tutor-' , self model , '-' , UUID new asString.
	modelFile := GtLlmModelFile new
			from: self model;
			system: self instructions instructionString.

	GtOllamaClient new
		createModel: internalModelName
		withModelFile: modelFile.

	self internalModel: internalModelName
]

{ #category : #accessing }
GtOllamaGtTutor >> initialize [
	super initialize.
	
	self ensureModel
]

{ #category : #accessing }
GtOllamaGtTutor >> instructions: anObject [
	super instructions: anObject.

	self ensureModel
]

{ #category : #accessing }
GtOllamaGtTutor >> internalModel [
	^ internalModel
]

{ #category : #accessing }
GtOllamaGtTutor >> internalModel: anObject [
	internalModel := anObject
]

{ #category : #accessing }
GtOllamaGtTutor >> model: aModel [
	super model: aModel.
	
	self ensureModel
]

{ #category : #accessing }
GtOllamaGtTutor >> summaryItems [
	^ {'Base model' -> self model.
		'Prompt' -> self instructions}
]
