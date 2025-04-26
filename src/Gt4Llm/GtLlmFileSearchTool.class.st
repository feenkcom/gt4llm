Class {
	#name : #GtLlmFileSearchTool,
	#superclass : #GtLlmTool,
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
GtLlmFileSearchTool >> name [
	^ 'File search'
]

{ #category : #'as yet unclassified' }
GtLlmFileSearchTool >> parameters [
	^ #()
]
