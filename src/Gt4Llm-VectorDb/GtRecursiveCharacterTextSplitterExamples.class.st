"
Examples for {{gtClass:GtRecursiveCharacterTextSplitter}}.
"
Class {
	#name : #GtRecursiveCharacterTextSplitterExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-VectorDb-Examples'
}

{ #category : #examples }
GtRecursiveCharacterTextSplitterExamples >> splitByParagraphThenWords [
	<gtExample>
	| splitter result |
	splitter := GtRecursiveCharacterTextSplitter basicNew.
	splitter initialize.
	splitter
		chunkSize: 12;
		chunkOverlap: 0;
		separators: { String lf , String lf . ' ' . '' };
		beDropSeparator.
	result := splitter splitText: 'abc def ghi jkl'.
	self assert: result equals: #('abc def ghi' 'jkl').
	^ result
]

{ #category : #examples }
GtRecursiveCharacterTextSplitterExamples >> splitKeepingSeparatorAtStart [
	<gtExample>
	| splitter result |
	splitter := GtRecursiveCharacterTextSplitter basicNew.
	splitter initialize.
	splitter
		chunkSize: 3;
		chunkOverlap: 0;
		separators: { String lf . '' };
		beKeepSeparatorAtStart.
	result := splitter splitText: 'aa', String lf, 'bb', String lf, 'cc'.
	self assert: result equals: #('aa' 'bb' 'cc').
	^ result
]

{ #category : #examples }
GtRecursiveCharacterTextSplitterExamples >> splitterWithSmallChunks [
	<gtExample>
	| splitter |
	splitter := GtRecursiveCharacterTextSplitter basicNew.
	splitter initialize.
	splitter
		chunkSize: 18;
		chunkOverlap: 0;
		separators: { String lf , String lf . String lf . ' ' . '' };
		beDropSeparator.
	^ splitter
]

{ #category : #examples }
GtRecursiveCharacterTextSplitterExamples >> whatIsGtSplitByParagraphThenWords [
	<gtExample>
	| splitter page text result |
	splitter := GtRecursiveCharacterTextSplitter new.
	splitter
		chunkSize: 1200;
		chunkOverlap: 300;
		separators: { String lf , String lf . ' ' . '' };
		beDropSeparator.
	page := LeDatabase gtBook pageNamed: 'What is Glamorous Toolkit?'.
	text := GtLLepiterContentExporter new
							page: page;
							export.
	self assert: text size > 3000.
	result := splitter splitText: text.
	self assert: result size >= (text size / 1200) truncated.
	^ result
]
