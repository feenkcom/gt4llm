Class {
	#name : #GtLSmaCCModel,
	#superclass : #Object,
	#instVars : [
		'grammars'
	],
	#category : #'Gt4Llm-SmaCC-Model'
}

{ #category : #'as yet unclassified' }
GtLSmaCCModel >> defineParser: parserClass andScanner: scannerClass using: aDefinitionString [
	^ self
		defineParser: parserClass
		as: ((GtSmaCCGrammar forDefinition: aDefinitionString)
				parserClassName: parserClass;
				scannerClassName: scannerClass;
				yourself)
]

{ #category : #'as yet unclassified' }
GtLSmaCCModel >> defineParser: parserClass as: aGrammar [
	^ grammars at: parserClass put: aGrammar
]

{ #category : #'as yet unclassified' }
GtLSmaCCModel >> grammarFor: aClassName [
	^ grammars
		at: aClassName
		ifAbsentPut: [ | class |
			class := Smalltalk globals at: aClassName asSymbol ifAbsent: [ ^ nil ].
			(class inheritsFrom: SmaCCParser) ifFalse: [ ^ nil ].
			GtSmaCCGrammar onParser: class ]
]

{ #category : #initialization }
GtLSmaCCModel >> initialize [
	super initialize.
	grammars := Dictionary new
]
