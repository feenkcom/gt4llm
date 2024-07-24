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
	aChat := GtOllamaChat new
			model: self internalModel;
			tutor: self;
			context: pipelineBuilder value.
	chats add: aChat.

	^ aChat
]

{ #category : #accessing }
GtOllamaGtTutor >> defaultModel [
	^ 'qwen2'
]

{ #category : #accessing }
GtOllamaGtTutor >> ensureModel [
	| internalModelName modelfileString |
	internalModelName := 'gt-tutor-' , self model , '-' , UUID new asString.
	modelfileString := GtLlmModelFile new
			from: self model;
			system: self instructions instructionString;
			content.

	GtOllamaClient new
		createModel: internalModelName
		withModelFile: modelfileString.

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
