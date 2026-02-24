Class {
	#name : #GtLSmaCCEditOperation,
	#superclass : #Object,
	#instVars : [
		'type',
		'newSource',
		'oldSource'
	],
	#category : 'Gt4Llm-SmaCC-Domain Objects'
}

{ #category : #private }
GtLSmaCCEditOperation >> findRuleIn: grammar [
	| ast |
	ast := SmaCCDefinitionParser
			parse: self oldSource
			startingAt: SmaCCDefinitionParser startingStateForRule.
	^ grammar rules detect: [ :each | each ast = ast ] ifNone: [  ]
]

{ #category : #accessing }
GtLSmaCCEditOperation >> newSource [
	^ newSource
]

{ #category : #accessing }
GtLSmaCCEditOperation >> newSource: anObject [
	newSource := anObject
]

{ #category : #accessing }
GtLSmaCCEditOperation >> newSourceDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'New source';
		accessor: #newSource;
		beOptional
]

{ #category : #accessing }
GtLSmaCCEditOperation >> oldSource [
	^ oldSource
]

{ #category : #accessing }
GtLSmaCCEditOperation >> oldSource: anObject [
	oldSource := anObject
]

{ #category : #accessing }
GtLSmaCCEditOperation >> oldSourceDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Old source';
		accessor: #oldSource;
		beOptional
]

{ #category : #executing }
GtLSmaCCEditOperation >> performDeleteOn: grammar [
	(self findRuleIn: grammar) delete
]

{ #category : #executing }
GtLSmaCCEditOperation >> performInsertOn: grammar [
	| ast |
	ast := SmaCCDefinitionParser
			parse: self newSource
			startingAt: SmaCCDefinitionParser startingStateForRule.
	ast isProductionRule
		ifTrue: [ ^ (grammar addProductionNamed: ast name source for: grammar)
				source: self newSource ].
	ast isTokenRule
		ifTrue: [ ^ (grammar addTokenNamed: ast name source for: grammar) source: self newSource ].
	ast isDirective ifTrue: [ ^ grammar addDirective: self newSource ]
]

{ #category : #executing }
GtLSmaCCEditOperation >> performModifyOn: grammar [
	(self findRuleIn: grammar) source: self newSource
]

{ #category : #executing }
GtLSmaCCEditOperation >> performOn: grammar [
	self type = 'insert' ifTrue: [ ^ self performInsertOn: grammar ].
	self type = 'delete' ifTrue: [ ^ self performDeleteOn: grammar ].
	self type = 'modify' ifTrue: [ ^ self performModifyOn: grammar ].
	self error: 'Invalid type'
]

{ #category : #accessing }
GtLSmaCCEditOperation >> type [
	^ type
]

{ #category : #accessing }
GtLSmaCCEditOperation >> type: anObject [
	type := anObject
]

{ #category : #accessing }
GtLSmaCCEditOperation >> typeDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Operation type';
		accessor: #type;
		beRequired
]

{ #category : #validating }
GtLSmaCCEditOperation >> validateDeleteFor: grammar onError: aBlock [
	self validateExistingRuleFor: grammar onError: aBlock
]

{ #category : #validating }
GtLSmaCCEditOperation >> validateExistingRuleFor: grammar onError: aBlock [
	(self findRuleIn: grammar)
		ifNil: [ aBlock
				value: (GtLProblemDomainObject new
						description: 'Could not find rule with source:' , String lf , String lf , self oldSource) ]
]

{ #category : #validating }
GtLSmaCCEditOperation >> validateFor: grammar onError: aBlock [
	self type = 'insert'
		ifTrue: [ ^ self validateInsertFor: grammar onError: aBlock ].
	self type = 'delete'
		ifTrue: [ ^ self validateDeleteFor: grammar onError: aBlock ].
	self type = 'modify'
		ifTrue: [ ^ self validateModifyFor: grammar onError: aBlock ].
	aBlock
		value: (self type
				ifNotNil: [ GtLProblemDomainObject new
						description: type , ' is not insert, delete or modify.' ]
				ifNil: [ GtLMissingArgumentDomainObject new
						arguments: nil;
						missingArgument: 'type' ])
]

{ #category : #validating }
GtLSmaCCEditOperation >> validateInsertFor: grammar onError: aBlock [
	self validateNewSourceOnError: aBlock
]

{ #category : #validating }
GtLSmaCCEditOperation >> validateModifyFor: grammar onError: aBlock [
	self validateExistingRuleFor: grammar onError: aBlock.
	self validateNewSourceOnError: aBlock
]

{ #category : #validating }
GtLSmaCCEditOperation >> validateNewSourceOnError: aBlock [
	[ SmaCCDefinitionParser
		parse: self newSource
		startingAt: SmaCCDefinitionParser startingStateForRule ]
		on: Error
		do: [ :ex | 
			aBlock
				value: (GtLProblemDomainObject new
						description: 'New source is invalid syntax: ' , String lf , String lf , self newSource) ]
]
