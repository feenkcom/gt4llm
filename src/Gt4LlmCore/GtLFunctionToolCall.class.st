Class {
	#name : #GtLFunctionToolCall,
	#superclass : #GtLEntity,
	#instVars : [
		'id',
		'arguments',
		'name',
		'tool',
		'result',
		'runtimeValues',
		'rawArguments'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #accessing }
GtLFunctionToolCall class >> leJsonV4Name [

	^ #gtLFunctionToolCall
]

{ #category : #serialization }
GtLFunctionToolCall class >> serializationProperties [
	^ {#id -> #id.
		#function -> #function}
]

{ #category : #visiting }
GtLFunctionToolCall >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLFunctionToolCall: self
]

{ #category : #accessing }
GtLFunctionToolCall >> anyArgument [
	^ self arguments anyOne
]

{ #category : #accessing }
GtLFunctionToolCall >> arguments [
	arguments ifNil: [
			rawArguments ifNotNil: [
				(rawArguments isKindOf: String)
					ifTrue: [ arguments := STONJSON fromString: rawArguments ]
					ifFalse: [ arguments := rawArguments ] ] ].
	^ arguments
]

{ #category : #accessing }
GtLFunctionToolCall >> arguments: anObject [
	arguments := anObject.
]

{ #category : #printing }
GtLFunctionToolCall >> argumentsDisplayString [
	^ ', ' join: (self arguments values collect: #gtDisplayString)
]

{ #category : #accessing }
GtLFunctionToolCall >> at: aString putRuntimeValue: anObject [
	^ runtimeValues at: aString put: anObject
]

{ #category : #accessing }
GtLFunctionToolCall >> description [
	^ tool ifNotNil: #description ifNil: [ '' ]
]

{ #category : #accessing }
GtLFunctionToolCall >> function [
	^ {'name' -> name.
		'arguments' -> (STONJSON toString: arguments)} asDictionary
]

{ #category : #accessing }
GtLFunctionToolCall >> function: aDict [
	name := aDict at: 'name'.
	arguments := aDict at: 'arguments'.

	(arguments isKindOf: String)
		ifTrue: [ arguments := STONJSON fromString: arguments ]
]

{ #category : #views }
GtLFunctionToolCall >> gtActionForResultFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousVectorIcons inspect;
		label: 'Result';
		tooltip: 'Spawn the result object';
		action: [ :button | 
			button phlow spawnObject: result ]
]

{ #category : #views }
GtLFunctionToolCall >> gtActionForToolFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousVectorIcons inspect;
		label: 'Tool';
		tooltip: 'Spawn the tool object';
		action: [ :button | 
			button phlow spawnObject: tool ]
]

{ #category : #'gt - extensions' }
GtLFunctionToolCall >> gtArgumentsFor: aView [
	<gtView>
	arguments ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Arguments';
		priority: 9;
		items: [ self arguments associations ];
		column: 'Name' text: #key width: 150;
		column: 'Value' text: #value;
		send: #value
]

{ #category : #views }
GtLFunctionToolCall >> gtDebugActionFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousVectorIcons debug;
		debugBlock: [ 
			| newCall |
			newCall := self class new.
			newCall function: self function.
			self tool performToolCall: newCall	];
		tooltip: 'Debug a new tool call'
]

{ #category : #printing }
GtLFunctionToolCall >> gtDisplayOn: aStream [
	self name ifNil: [ ^ super gtDisplayOn: aStream ].
	aStream
		nextPutAll: self name;
		nextPut: $(;
		nextPutAll: (self argumentsDisplayString);
		nextPut: $)
]

{ #category : #'gt - extensions' }
GtLFunctionToolCall >> gtInspectorTargetModels [
	| collection |
	collection := {result}.
	^ (result respondsTo: #gtInspectorTargetModels)
		ifTrue: [ collection , result gtInspectorTargetModels ]
		ifFalse: [ collection ]
]

{ #category : #'gt - extensions' }
GtLFunctionToolCall >> gtViewsInContext: aPhlowContext [
	| collectedViews |
	collectedViews := Array
			streamContents: [ :aStream | 
				aStream nextPutAll: (super gtViewsInContext: aPhlowContext).
				self gtInspectorTargetModels
					do: [ :eachTargetModel | 
						aStream
							nextPutAll: (GtPhlowViewsCollector new
									fromObject: eachTargetModel;
									pragmaNames: GtLSettings messageViewPragmaNames;
									collect) ] ].

	GtPhlowUtility sortByPriority: collectedViews.

	^ collectedViews
]

{ #category : #printing }
GtLFunctionToolCall >> humanReadable [
	^ self name , ' ('
		, (', '
				join: (self arguments associations
						collect: [ :anArgument | anArgument key , ': ' , anArgument value asString])), ')'
]

{ #category : #accessing }
GtLFunctionToolCall >> id [
	^ id
]

{ #category : #accessing }
GtLFunctionToolCall >> id: anObject [
	id := anObject
]

{ #category : #initialization }
GtLFunctionToolCall >> initialize [
	super initialize.
	runtimeValues := Dictionary new.
]

{ #category : #testing }
GtLFunctionToolCall >> isFinished [
	^ result notNil
]

{ #category : #accessing }
GtLFunctionToolCall >> name [
	^ name
]

{ #category : #accessing }
GtLFunctionToolCall >> name: anObject [
	name := anObject
]

{ #category : #actions }
GtLFunctionToolCall >> performedByTool: aTool [
	tool := aTool
]

{ #category : #printing }
GtLFunctionToolCall >> printOn: aStream [
	super printOn: aStream.

	self name ifNil: [ ^ self ].

	aStream
		nextPut: $(;
		nextPutAll: self name;
		nextPut: $)
]

{ #category : #accessing }
GtLFunctionToolCall >> rawArguments [
	^ rawArguments
]

{ #category : #accessing }
GtLFunctionToolCall >> rawArguments: aStringOrDictionary [
	rawArguments := aStringOrDictionary
]

{ #category : #accessing }
GtLFunctionToolCall >> rawArgumentsJsonString [
	^ (rawArguments isKindOf: String)
				ifTrue: [ rawArguments ]
				ifFalse: [  NeoJSONWriter toStringPretty: rawArguments ] 
]

{ #category : #accessing }
GtLFunctionToolCall >> responseInputForAnthropicMessagesAPI [
	^ {
		'content' ->{{
			'type' -> 'tool_use'.
			'id' -> self id.
			'name' -> self name.
			'input' ->  self rawArguments} asDictionary}.
		'role' -> 'assistant' } asDictionary 
	
]

{ #category : #accessing }
GtLFunctionToolCall >> responseInputForOpenAIResponsesAPI [
	^ {'type' -> 'function_call'.
		'call_id' -> self id.
		'name' -> self name.
		'arguments' -> self rawArgumentsJsonString} asDictionary
]

{ #category : #accessing }
GtLFunctionToolCall >> result [
	<return: #TGtLDomainObject>
	^ result
]

{ #category : #accessing }
GtLFunctionToolCall >> result: aToolResult [
	result := aToolResult
]

{ #category : #accessing }
GtLFunctionToolCall >> tool [
	^ tool
]
