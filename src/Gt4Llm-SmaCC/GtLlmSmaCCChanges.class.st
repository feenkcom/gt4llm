Class {
	#name : #GtLlmSmaCCChanges,
	#superclass : #Object,
	#instVars : [
		'originalGrammar',
		'newGrammar',
		'parserClass'
	],
	#category : #'Gt4Llm-SmaCC-Model'
}

{ #category : #private }
GtLlmSmaCCChanges class >> changesFromPrevious: previousMessages [
	previousMessages
		reverseDo: [ :each | 
			[ ^ (self fromMessage: previousMessages last) newGrammar ]
				on: Error
				do: [ :ex | ex return ] ]
]

{ #category : #'instance creation' }
GtLlmSmaCCChanges class >> fromMessage: aMessage [
	| json changes previousMessages |
	json := STON fromString: (aMessage contentJson at: 'SmaCC Edits').
	changes := self new.
	changes parserClass: (json at: 'parserClass') asClass.
	previousMessages := (aMessage chat messages
			first: (aMessage chat messages indexOf: aMessage) - 1)
			select: [ :each | each class = aMessage and: [ each gtIsSmaCCEditMessage ] ].
	changes
		originalGrammar: (previousMessages isEmpty
				ifTrue: [ GtSmaCCGrammar onParser: changes parserClass ]
				ifFalse: [ self changesFromPrevious: previousMessages ]).
	changes updateGrammarFrom: (json at: 'edits' ifAbsent: [ #() ]).
	^ changes
]

{ #category : #accessing }
GtLlmSmaCCChanges class >> smaccFormatDescription [
	^ GtLlmAssistantFormatDescription new
		name: 'SmaCC Edits';
		priority: 10;
		format: 'Edits for SmaCC grammars wrapped in a JSON object.';
		example: 'The result is a JSON object that specifies the parser class, and a list of edit operations to transform the SmaCC parser. An edit operation has a type which can be insert, delete or modify. Insert operations have a newSource property that contain the new production, token or directive rule that should be inserted into the grammar. Delete operations specify a rule that should be removed from the grammar. They should contain an oldSource property that has current source that of the rule that is to be removed. Finally, the modify operation should contain both an oldSource and a newSource property. When applied the modify operation will replace the rule with the oldSource to be newSource. JSON is the format of the edit objects. Special character that occur inside of JSON strings should be escaped to be valid JSON syntax. For example, a double quote character inside a string should be preceded by a backslash character.
		
Example:
```json
{
	"parserClass": "SimpleMathParser",
	"edits": [
		{"type":"insert", "newSource":"%glr;"},
		{"type":"modify", "oldSource":"expression : addition | <number>;", "newSource":"expression : expression \"+\" <number>;"},
		{"type":"delete", "oldSource":"addition : expression \"+\" <number>;"}	
	]
}
```
'
]

{ #category : #views }
GtLlmSmaCCChanges >> gtDiffFor: aView [
	<gtView>
	^ aView forward
		title: 'Diff';
		object: [ GtDiffBuilder
				computeDifferencesFrom: originalGrammar source
				to: newGrammar source
				using: GtCharacterGroupDiffSplitter words ];
		view: #gtTextView:
]

{ #category : #views }
GtLlmSmaCCChanges >> gtDiffViewFor: aView [
	<gtView>
	^ aView forward
		title: 'Diff';
		object: [ GtDiffBuilder
				computeDifferencesFrom: originalGrammar source
				to: newGrammar source
				using: GtCharacterGroupDiffSplitter words ];
		view: #gtTextView:
]

{ #category : #views }
GtLlmSmaCCChanges >> gtGrammarFor: aView [
	<gtView>
	^ aView forward
		title: 'Grammar';
		object: [ newGrammar ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtLlmSmaCCChanges >> newGrammar [
	^ newGrammar
]

{ #category : #accessing }
GtLlmSmaCCChanges >> newGrammar: anObject [
	newGrammar := anObject
]

{ #category : #accessing }
GtLlmSmaCCChanges >> originalGrammar [
	^ originalGrammar
]

{ #category : #accessing }
GtLlmSmaCCChanges >> originalGrammar: anObject [
	originalGrammar := anObject
]

{ #category : #accessing }
GtLlmSmaCCChanges >> parserClass [
	^ parserClass
]

{ #category : #accessing }
GtLlmSmaCCChanges >> parserClass: anObject [
	parserClass := anObject
]

{ #category : #initialization }
GtLlmSmaCCChanges >> updateGrammarFrom: aCollection [
	newGrammar := GtSmaCCGrammar new.
	newGrammar scannerClassName: originalGrammar scannerClassName.
	newGrammar parserClassName: originalGrammar parserClassName.
	newGrammar updateSource: originalGrammar source.
	aCollection do: [ :each | self updateGrammarFromEdit: each ]
]

{ #category : #initialization }
GtLlmSmaCCChanges >> updateGrammarFromEdit: aDictionary [
	| type newSource oldSource rule ast |
	type := aDictionary at: 'type'.
	type = 'insert'
		ifTrue: [ newSource := aDictionary at: 'newSource'.
			ast := SmaCCDefinitionParser
					parse: newSource
					startingAt: SmaCCDefinitionParser startingStateForRule.
			ast isProductionRule
				ifTrue: [ ^ (newGrammar addProductionNamed: ast name source for: newGrammar)
						source: newSource ].
			ast isTokenRule
				ifTrue: [ ^ (newGrammar addTokenNamed: ast name source for: newGrammar)
						source: newSource ].
			ast isDirective ifTrue: [ ^ newGrammar addDirective: newSource ] ]
		ifFalse: [ oldSource := aDictionary at: 'oldSource'.
			ast := SmaCCDefinitionParser
					parse: oldSource
					startingAt: SmaCCDefinitionParser startingStateForRule.
			rule := newGrammar rules detect: [ :each | each ast = ast ].
			type = 'delete'
				ifTrue: [ rule delete ]
				ifFalse: [ rule source: (aDictionary at: 'newSource') ] ]
]
