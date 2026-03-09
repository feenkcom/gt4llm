"
Examples for GtLSmalltalkCodeEvaluationResult and related domain objects.
"
Class {
	#name : #GtLSmalltalkCodeEvaluationResultExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #'examples - supporting' }
GtLSmalltalkCodeEvaluationResultExamples >> simpleObjectValue [
	<gtExample>
	^ GtLSerializedObjectValueExamples new simpleObjectValue
]

{ #category : #examples }
GtLSmalltalkCodeEvaluationResultExamples >> simpleResult [
	<gtExample>
	| result |
	result := GtLSmalltalkCodeEvaluationResult new
		code: '1 + 2';
		object: 3;
		objectValue: self simpleObjectValue;
		objectId: 'test-uuid-123';
		yourself.
	
	self assert: result code equals: '1 + 2'.
	self assert: result object equals: 3.
	self assert: result objectId equals: 'test-uuid-123'.
	self assert: result objectValue objectClassName equals: 'SmallInteger'.
	
	^ result
]

{ #category : #examples }
GtLSmalltalkCodeEvaluationResultExamples >> simpleResultSerialization [
	<gtExample>
	| result jsonObject expected |
	result := self simpleResult.
	jsonObject := GtMagritteJSONDataExporter exportObject: result.
	
	expected := NeoJSONObject new
		at: 'code' put: '1 + 2';
		at: 'objectValue' put: (NeoJSONObject new
			at: 'objectClassName' put: 'SmallInteger';
			at: 'superclassName' put: 'Integer';
			at: 'packageName' put: 'Kernel';
			at: 'objectPrintString' put: '3';
			at: 'phlowViews' put: (NeoJSONArray with: (NeoJSONObject new
				at: 'methodName' put: 'gtPrintFor:';
				at: 'title' put: 'Print';
				yourself));
			at: 'allInstanceSlots' put: (NeoJSONArray new);
			yourself);
		at: 'objectId' put: 'test-uuid-123';
		yourself.
	
	self assert: jsonObject equals: expected.
	
	^ jsonObject
]
