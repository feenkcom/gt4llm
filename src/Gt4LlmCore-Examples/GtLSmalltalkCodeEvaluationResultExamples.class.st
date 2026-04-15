"
Examples for GtLSmalltalkCodeEvaluationResult and related domain objects.
"
Class {
	#name : #GtLSmalltalkCodeEvaluationResultExamples,
	#superclass : #GtLDomainObjectExamples,
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
	<return: #GtLSmalltalkCodeEvaluationResult>
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
GtLSmalltalkCodeEvaluationResultExamples >> simpleResultDataViewSerialization [
	<gtExample>
	<return: #Dictionary>
	| result compositeView dataBlock jsonData expectedPhlowViews expectedObjectValue expectedJson |
	result := self simpleResult.
	
	compositeView := result llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 2.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	
	expectedPhlowViews := NeoJSONArray with: (NeoJSONObject new
		at: 'methodName' put: 'gtPrintFor:';
		at: 'title' put: 'Print';
		yourself).
	
	expectedObjectValue := NeoJSONObject new
		at: 'allInstanceSlots' put: NeoJSONArray new;
		at: 'objectClassName' put: 'SmallInteger';
		at: 'objectPrintString' put: '3';
		at: 'packageName' put: 'Kernel';
		at: 'phlowViews' put: expectedPhlowViews;
		at: 'superclassName' put: 'Integer';
		yourself.
	
	expectedJson := Dictionary new
		at: #code put: '1 + 2';
		at: 'objectDetails' put: Dictionary new;
		at: #objectId put: 'test-uuid-123';
		at: #objectValue put: expectedObjectValue;
		yourself.
	
	self assert: jsonData equals: expectedJson.
	
	^ jsonData
]
