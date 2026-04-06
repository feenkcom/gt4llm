"
Examples for GtLRemoteExamplesReportDomainObject and GtLRemoteExampleReportDomainObject.
"
Class {
	#name : #GtLRemoteExampleReportDomainObjectExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #'examples - report' }
GtLRemoteExampleReportDomainObjectExamples >> basicExamplesReport [
	"Create a basic remote examples report domain object"
	<gtExample>
	| report |
	report := GtLRemoteExamplesReportDomainObject new.
	
	self assert: report errorMessages isEmpty.
	self assert: report results isEmpty.
	self assert: report exception isNil.
	
	^ report
]

{ #category : #'examples - report' }
GtLRemoteExampleReportDomainObjectExamples >> emptyExamplesReportDataViewSerialization [
	"Verify data view serialization for empty report"
	<gtExample>
	| report compositeView dataBlock jsonData |
	report := self basicExamplesReport.
	
	compositeView := report llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	
	jsonData := dataBlock llmJsonData.
	self assert: jsonData equals: Dictionary new.
	
	^ dataBlock
]

{ #category : #'examples - report' }
GtLRemoteExampleReportDomainObjectExamples >> examplesReportWithErrors [
	"Create a report with error messages"
	<gtExample>
	| report |
	report := GtLRemoteExamplesReportDomainObject new
		errorMessages: #('Error 1' 'Error 2').
	
	self assert: report errorMessages size equals: 2.
	self assert: report errorMessages first equals: 'Error 1'.
	
	^ report
]

{ #category : #'examples - report' }
GtLRemoteExampleReportDomainObjectExamples >> examplesReportWithErrorsDataViewSerialization [
	"Verify data view serialization for report with errors"
	<gtExample>
	| report compositeView dataBlock jsonData expected |
	report := self examplesReportWithErrors.
	
	compositeView := report llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	
	jsonData := dataBlock llmJsonData.
	expected := Dictionary new
		at: #errors put: #('Error 1' 'Error 2');
		yourself.
	self assert: jsonData equals: expected.
	
	^ dataBlock
]
