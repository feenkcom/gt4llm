"
GtLJsonPlaceholderTool is used when reconstructing chats from an LLM datasource, as the datasource is missing information needed to reconstruct the original tool.
"
Class {
	#name : #GtLJsonPlaceholderTool,
	#superclass : #GtLAbstractFunctionTool,
	#instVars : [
		'rawData',
		'entity'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLJsonPlaceholderTool >> description [

	^ entity description
]

{ #category : #accessing }
GtLJsonPlaceholderTool >> entity [
	^ entity
]

{ #category : #accessing }
GtLJsonPlaceholderTool >> entity: anObject [
	entity := anObject
]

{ #category : #accessing }
GtLJsonPlaceholderTool >> name [

	^ entity name
]

{ #category : #accessing }
GtLJsonPlaceholderTool >> parametersJsonSchemaDictionary [

	^ entity parameters
]

{ #category : #execution }
GtLJsonPlaceholderTool >> privatePerformToolCall: aToolCall inContext: anExecutionContext [

	self error: self class name asString, ' should be replaced by the appropriate tool prior to use.'
]

{ #category : #accessing }
GtLJsonPlaceholderTool >> type [

	^ entity type
]
