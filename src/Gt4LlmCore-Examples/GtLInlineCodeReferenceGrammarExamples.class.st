Class {
	#name : #GtLInlineCodeReferenceGrammarExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLInlineCodeReferenceGrammarExamples >> classAndSymbol [
	<gtExample>
	| grammar className symbol |
	grammar := GtLInlineCodeReferenceGrammar new.
	className := grammar parse: '  MissingInlineReferenceClass  '.
	symbol := grammar parse: '  asString  '.
	self assert: className equals: 'MissingInlineReferenceClass'.
	self assert: symbol equals: 'asString'.
	self assert: symbol isSymbol not.
	^ {className.
		symbol}
]

{ #category : #examples }
GtLInlineCodeReferenceGrammarExamples >> methodReference [
	<gtExample>
	| grammar keywordMethod binaryMethod |
	grammar := GtLInlineCodeReferenceGrammar new.
	keywordMethod := grammar parse: '  Point class >> x:y:  '.
	binaryMethod := grammar parse: 'SmallInteger>>#+'.
	self assert: keywordMethod first equals: 'Point'.
	self assert: keywordMethod second last equals: 'class'.
	self assert: keywordMethod fourth equals: 'x:y:'.
	self assert: binaryMethod first equals: 'SmallInteger'.
	self assert: binaryMethod second isNil.
	self assert: binaryMethod fourth equals: '+'.
	^ {keywordMethod.
		binaryMethod}
]

{ #category : #examples }
GtLInlineCodeReferenceGrammarExamples >> noise [
	<gtExample>
	| grammar source |
	grammar := GtLInlineCodeReferenceGrammar new.
	source := 'See Object>>#asString'.
	self assert: (grammar parse: source) equals: source.
	^ grammar
]
