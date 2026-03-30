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
	<return: #GtLCompositeDataBlock>
	| domainObject compositeView dataBlock jsonData expectedJson |
	domainObject := self classesSearchResultWithMatches.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#foundClassNames -> (NeoJSONArray withAll: #('Object' 'String')).
		#mayHaveMore -> false
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
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
