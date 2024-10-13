Class {
	#name : #GtLlmTutorActionExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Gt4Llm-Examples'
}

{ #category : #'as yet unclassified' }
GtLlmTutorActionExamples >> actionWithExampleWithJsonContainingQuote [
	<gtExample>
	| action |
	action := GtLlmTutorAction new
			name: 'Some action';
			description: 'Some description.';
			addExample: self exampleWithJsonContainingQuote.
	self shouldnt: [ RBParser parseMethod: action asMethodSource ] raise: Error.
]

{ #category : #'as yet unclassified' }
GtLlmTutorActionExamples >> exampleWithJsonContainingQuote [
	<gtExample>
	| jsonString json example |
	jsonString := '{"Action":"Some action","Text":"Some text","Post":"String with '' inside."}'.
	json := STONJSON fromString: jsonString.
	example := GtLlmTutorActionExample new
			input: json;
			output: json.
	self
		shouldnt: [ RBParser parseExpression: example asExpressionSource ]
		raise: Error.
	^ example
]
