Class {
	#name : #GtLlmFileSearchTool,
	#superclass : #GtLlmTool,
	#instVars : [
		'vectorStoreIds'
	],
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmFileSearchTool >> defaultType [
	^ 'file_search'
]

{ #category : #'as yet unclassified' }
GtLlmFileSearchTool >> description [
	^ 'Search the files attached to the chat'
]

{ #category : #'as yet unclassified' }
GtLlmFileSearchTool >> functionResponse [
	^ {'type' -> type.
		'vector_store_ids' -> self vectorStoreIds} asDictionary
]

{ #category : #'as yet unclassified' }
GtLlmFileSearchTool >> initialize [
	super initialize.
	
	vectorStoreIds := {}
]

{ #category : #'as yet unclassified' }
GtLlmFileSearchTool >> name [
	^ 'File search'
]

{ #category : #'as yet unclassified' }
GtLlmFileSearchTool >> parameters [
	^ #()
]

{ #category : #accessing }
GtLlmFileSearchTool >> vectorStoreIds [
	^ vectorStoreIds
]

{ #category : #accessing }
GtLlmFileSearchTool >> vectorStoreIds: anObject [
	vectorStoreIds := anObject
]
