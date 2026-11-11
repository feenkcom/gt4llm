Class {
	#name : #GtLAbstractFunctionTool,
	#superclass : #GtLTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #testiung }
GtLAbstractFunctionTool class >> isAbstract [
	^ self name = #GtLAbstractFunctionTool
]

{ #category : #accessing }
GtLAbstractFunctionTool class >> serializationProperties [
	^ {#type -> #type. }
]

{ #category : #accessing }
GtLAbstractFunctionTool >> computeParametersFormat [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLAbstractFunctionTool >> description [
	^ self subclassResponsibility
]

{ #category : #'api - responses' }
GtLAbstractFunctionTool >> functionAnthropic [
	^ {'name' -> self name.
		'description' -> self description.
		'input_schema' -> self parametersJsonSchemaDictionary} asDictionary
]

{ #category : #'api - responses' }
GtLAbstractFunctionTool >> functionGemini [
	^ {'name' -> self name.
		'description' -> self description.
		'parameters' -> self parametersJsonSchemaDictionary} asDictionary
]

{ #category : #'api - responses' }
GtLAbstractFunctionTool >> functionMCP [
	^
	{'name' -> self name.
	'description' -> self description.
	'inputSchema' -> self parametersJsonSchemaDictionary}
			asDictionary
]

{ #category : #'api - responses' }
GtLAbstractFunctionTool >> functionOpenAI [
	^ {'name' -> self name.
		'type' -> self type.
		'description' -> self description.
		'parameters' -> self parametersJsonSchemaDictionary} asDictionary
]

{ #category : #'gt - extensions' }
GtLAbstractFunctionTool >> gtParameterRowsOfSchema: aSchemaDictionary [
	"Answer the rows {name. schema. isRequired} directly nested in a JSON schema.
	Arrays are transparent (their item rows are answered), and anyOf answers the rows of all variants."

	| required |
	aSchemaDictionary isDictionary ifFalse: [ ^ #() ].
	aSchemaDictionary
		at: 'items'
		ifPresent: [ :anItemsSchema | ^ self gtParameterRowsOfSchema: anItemsSchema ].
	aSchemaDictionary
		at: 'anyOf'
		ifPresent: [ :theVariants | ^ theVariants flatCollect: [ :each | self gtParameterRowsOfSchema: each ] ].
	required := aSchemaDictionary at: 'required' ifAbsent: [ #() ].
	^ (aSchemaDictionary at: 'properties' ifAbsent: [ ^ #() ]) associations
		collect: [ :each | 
			{each key.
				each value.
				required includes: each key} ]
]

{ #category : #'gt - extensions' }
GtLAbstractFunctionTool >> gtParameterTypeOfSchema: aSchemaDictionary [
	| type |
	aSchemaDictionary isDictionary ifFalse: [ ^ '' ].
	aSchemaDictionary
		at: 'anyOf'
		ifPresent: [ :theVariants | ^ 'any of ' , theVariants size printString ].
	type := (aSchemaDictionary at: 'type' ifAbsent: [ '' ]) asString.
	type = 'array' ifFalse: [ ^ type ].
	^ 'array of '
		, (self gtParameterTypeOfSchema: (aSchemaDictionary at: 'items' ifAbsent: [ nil ]))
]

{ #category : #'gt - extensions' }
GtLAbstractFunctionTool >> gtParametersFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Parameters';
		priority: 6;
		items: [ self gtParameterRowsOfSchema: self parametersJsonSchemaDictionary ];
		children: [ :aRow | self gtParameterRowsOfSchema: aRow second ];
		expandUpTo: 2;
		column: 'Name' text: [ :aRow | aRow first ];
		column: 'Type' text: [ :aRow | self gtParameterTypeOfSchema: aRow second ];
		column: 'Required'
			text: [ :aRow | aRow third ifTrue: [ 'yes' ] ifFalse: [ '' ] ]
			width: 70;
		column: 'Description'
			text: [ :aRow | 
				(aRow second at: 'description' ifAbsent: [ '' ]) asString lines
					ifEmpty: [ '' ]
					ifNotEmpty: [ :theLines | theLines first ] ]
			weight: 3;
		send: [ :aRow | aRow second ]
]

{ #category : #'gt - extensions' }
GtLAbstractFunctionTool >> gtParametersJsonFor: aView [
	<gtView>
	^ aView forward
		title: 'Parameters schema';
		priority: 7;
		object: [ self parametersJsonSchemaDictionary ];
		view: #gtJsonFor:
]

{ #category : #views }
GtLAbstractFunctionTool >> gtViewDescriptionFor: aView [
	<gtView>
	^ aView forward
		title: 'Description';
		priority: 5;
		object: [ GtLMarkdown new content: self description ];
		view: #gtMarkdownFor:
]

{ #category : #accessing }
GtLAbstractFunctionTool >> name [

	^ nil
]

{ #category : #'api - responses' }
GtLAbstractFunctionTool >> parametersJsonSchemaDictionary [
	| parametersFormat |
	parametersFormat := self computeParametersFormat.
	^ parametersFormat asJsonSchemaDictionary
]

{ #category : #execution }
GtLAbstractFunctionTool >> performToolCall: aToolCall [
	^ self 
			performToolCall: aToolCall 
			inContext: (GtLToolExecutionContext new)
]

{ #category : #executing }
GtLAbstractFunctionTool >> performToolCall: aToolCall inContext: anExecutionContext [
	| domainObject resultObject |
	
	aToolCall markAsStartedByTool: self.
	
	domainObject := self 
		privatePerformToolCall: aToolCall 
		inContext: anExecutionContext.
	resultObject := self resultObjectFromDomainObject: domainObject.
	
	aToolCall updateResult: resultObject.
	
	^ resultObject
]

{ #category : #execution }
GtLAbstractFunctionTool >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	^ self subclassResponsibility
]

{ #category : #utils }
GtLAbstractFunctionTool >> resultObjectFromDomainObject: domainObject [ 

	^GtLWrappedObjectModel new 
			model:  domainObject
]

{ #category : #accessing }
GtLAbstractFunctionTool >> type [
	^ 'function'
]
