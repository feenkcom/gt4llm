Class {
	#name : #GtLInlineCodeReferenceGrammar,
	#superclass : #PP2CompositeNode,
	#instVars : [
		'identifierPart',
		'className',
		'classReference',
		'symbol',
		'selectorName',
		'keyword',
		'binarySelector',
		'selector',
		'classSide',
		'methodReference',
		'noise'
	],
	#category : #'Gt4LlmCore-UI'
}

{ #category : #grammar }
GtLInlineCodeReferenceGrammar >> binarySelector [
	^ (PP2PredicateObjectNode anyOf: '+-*/\~<>=@%|&,?!') plus
]

{ #category : #grammar }
GtLInlineCodeReferenceGrammar >> className [
	^ ((PP2PredicateObjectNode new
		predicate: [ :character | character isUppercase ];
		predicateMessage: 'uppercase letter expected';
		yourself) , identifierPart star) flatten
]

{ #category : #grammar }
GtLInlineCodeReferenceGrammar >> classReference [
	^ className trim end
]

{ #category : #grammar }
GtLInlineCodeReferenceGrammar >> classSide [
	^ (#space asPParser plus , 'class' asPParser) optional
]

{ #category : #grammar }
GtLInlineCodeReferenceGrammar >> identifierPart [
	^ #word asPParser / $_ asPParser
]

{ #category : #grammar }
GtLInlineCodeReferenceGrammar >> keyword [
	^ selectorName , $: asPParser
]

{ #category : #grammar }
GtLInlineCodeReferenceGrammar >> methodReference [
	^ (className , classSide , ('>>' asPParser trim , $# asPParser optional)
		, selector) trim end
]

{ #category : #grammar }
GtLInlineCodeReferenceGrammar >> noise [
	^ #any asPParser star flatten end
]

{ #category : #grammar }
GtLInlineCodeReferenceGrammar >> selector [
	^ ((keyword plus / selectorName , (identifierPart / $: asPParser) not)
		/ binarySelector) flatten
]

{ #category : #grammar }
GtLInlineCodeReferenceGrammar >> selectorName [
	^ #letter asPParser / $_ asPParser , identifierPart star
]

{ #category : #accessing }
GtLInlineCodeReferenceGrammar >> start [
	^ classReference / symbol / methodReference / noise
]

{ #category : #grammar }
GtLInlineCodeReferenceGrammar >> symbol [
	^ ((PP2PredicateObjectNode new
		predicate: [ :character | character isLowercase ];
		predicateMessage: 'lowercase letter expected';
		yourself) , identifierPart star) flatten trim end
]
