Class {
	#name : #GtLSamplingProfilerExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLSamplingProfilerExamples >> textReportLlmView [
	<gtExample>
	| profiler view |
	profiler := GtSamplingProfiler new.
	profiler spyOn: [ 1000 timesRepeat: [ 1 + 1 ] ].
	view := profiler llmTextReportFor: GtLDataView empty.
	self assert: (view llmJsonData at: 'report') equals: profiler textReport.
	self assert: profiler textReport notEmpty.
	self assert: (profiler llmDataViewsInContext: GtLDataViewContext new) notEmpty.
	^ profiler
]
