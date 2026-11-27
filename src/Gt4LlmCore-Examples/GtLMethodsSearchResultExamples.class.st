"
Examples for GtLMethodsSearchResult.
"
Class {
	#name : #GtLMethodsSearchResultExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLMethodsSearchResultExamples >> methodFilterResultViewIsBounded [
	<gtExample>
	| methods filter data |
	methods := Object methods.
	50
		to: 51
		do: [ :size | 
			filter := GtSearchFixedMethodsFilter new methods: (methods first: size).
			data := (filter llmDataViewsFor: GtLDataView new) serializeToLlmPrimiteData
					llmJsonData at: 'methodMatches'.
			self assert: (data at: 'foundMethods') size equals: 50.
			self assert: (data at: 'mayHaveMore') equals: size = 51 ].
	^ filter
]

{ #category : #examples }
GtLMethodsSearchResultExamples >> methodsSearchResultCreation [
	<gtExample>
	| references result |
	references := { GtLMagritteToolForMethodReferences >> #name }.
	result := GtLMethodsSearchResult fromReferences: references.
	self assert: result foundMethods size equals: 1.
	self assert: result foundMethods first methodName equals: 'name'.
	self assert: result mayHaveMore not.
	^ result
]

{ #category : #examples }
GtLMethodsSearchResultExamples >> methodsSearchResultDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock referenceJson expected |
	domainObject := self methodsSearchResultCreation.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	referenceJson := NeoJSONObject new
		at: 'classSide' put: false;
		at: 'methodClassName' put: 'GtLMagritteToolForMethodReferences';
		at: 'methodName' put: 'name';
		yourself.
	expected := Dictionary new
		at: 'foundMethods' put: (NeoJSONArray with: referenceJson);
		at: 'mayHaveMore' put: false;
		yourself.
	self assertDataBlock: dataBlock hasLlmJsonData: expected.
	
	^ dataBlock
]

{ #category : #examples }
GtLMethodsSearchResultExamples >> methodsSearchResultForTraitCopies [
	"A search can match the copies that classes get from a trait; the result names the trait method, once"

	<gtExample>
	| result |
	result := GtLMethodsSearchResult
			fromReferences: {GtLExampleTraitUser >> #traitMethod.
					TGtLExampleTrait >> #traitMethod.
					GtLExampleComposedTraitUser >> #traitMethod}.
	self
		assert: result foundMethods asArray
		equals: {GtLMethodReference fromCompiledMethod: TGtLExampleTrait >> #traitMethod}.
	self assert: result foundMethods first existsInImage.
	self assert: result mayHaveMore not.
	^ result
]
