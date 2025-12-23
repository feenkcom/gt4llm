Class {
	#name : #GtLPlainObjectInputModel,
	#superclass : #GtLInputModel,
	#category : #Gt4LlmCore
}

{ #category : #'as yet unclassified' }
GtLPlainObjectInputModel >> addContentTo: aDictionary [
	aDictionary 
		at: name 
		put: (GtLlmAssistantLibraryForGt valueHolderForObject: model) contentValue
]

{ #category : #'as yet unclassified' }
GtLPlainObjectInputModel >> addInstructionsTo: aMessageInstructions [

	aMessageInstructions
		addSection: (GtLlmInstructionSection new
				source: self;
				title: self name;
				body: '')
]
