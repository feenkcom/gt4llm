Class {
	#name : #GtLlmFileSearchTool,
	#superclass : #GtLlmTool,
	#instVars : [
		'vectorStoreIds'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmFileSearchTool class >> leJsonV4Name [

	^ #gtLlmFileSearchTool
]

{ #category : #visiting }
GtLlmFileSearchTool >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLlmFileSearchTool: self
]

{ #category : #'as yet unclassified' }
GtLlmFileSearchTool >> functionResponse [
	^ {'type' -> 'file_search'.
		'description' -> 'Search the files attached to the chat'.
		'vector_store_ids' -> self vectorStoreIds} asDictionary
]

{ #category : #'as yet unclassified' }
GtLlmFileSearchTool >> initialize [
	super initialize.
	
	vectorStoreIds := {}
]

{ #category : #accessing }
GtLlmFileSearchTool >> vectorStoreIds [
	^ vectorStoreIds
]

{ #category : #accessing }
GtLlmFileSearchTool >> vectorStoreIds: anObject [
	vectorStoreIds := anObject
]
