"
I am an abstract superclass for data view examples. I provide common utilities for testing data view serialization.
"
Class {
	#name : #GtLDataViewExamples,
	#superclass : #Object,
	#traits : 'TGtLDataViewAssertions + TGtLDataBlockSerializationAssertions',
	#classTraits : 'TGtLDataViewAssertions classTrait + TGtLDataBlockSerializationAssertions classTrait',
	#category : #'Gt4LlmCore-Examples-Data Views'
}
