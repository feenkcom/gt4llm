"
Examples for GtLClassesSearchResult.
"
Class {
	#name : #GtLClassesSearchResultExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLClassesSearchResultExamples >> classesSearchResultDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock expectedJson |
	domainObject := self classesSearchResultWithMatches.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	expectedJson := {
		#foundClassNames -> (NeoJSONArray withAll: #('Object' 'String')).
		#mayHaveMore -> false
	} asDictionary.
	self assertDataBlock: dataBlock hasLlmJsonData: expectedJson.
	
	^ dataBlock
]

{ #category : #examples }
GtLClassesSearchResultExamples >> classesSearchResultWithMatches [
	<gtExample>
	| matches result |
	matches := { Object. String }.
	result := GtLClassesSearchResult fromClasses: matches.
	self assert: result foundClassNames equals: #('Object' 'String').
	self assert: result mayHaveMore not.
	^ result
]
