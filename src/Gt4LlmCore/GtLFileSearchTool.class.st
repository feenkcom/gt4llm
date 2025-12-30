Class {
	#name : #GtLFileSearchTool,
	#superclass : #GtLTool,
	#instVars : [
		'vectorStoreIds'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLFileSearchTool class >> leJsonV4Name [

	^ #gtLlmFileSearchTool
]

{ #category : #visiting }
GtLFileSearchTool >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLlmFileSearchTool: self
]

{ #category : #'as yet unclassified' }
GtLFileSearchTool >> functionResponse [
	^ {'type' -> 'file_search'.
		'description' -> 'Search the files attached to the chat'.
		'vector_store_ids' -> self vectorStoreIds} asDictionary
]

{ #category : #'as yet unclassified' }
GtLFileSearchTool >> initialize [
	super initialize.
	
	vectorStoreIds := {}
]

{ #category : #accessing }
GtLFileSearchTool >> vectorStoreIds [
	^ vectorStoreIds
]

{ #category : #accessing }
GtLFileSearchTool >> vectorStoreIds: anObject [
	vectorStoreIds := anObject
]
