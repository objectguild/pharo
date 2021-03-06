Class {
	#name : #RBRenameTemporaryTest,
	#superclass : #RBRefactoringTest,
	#category : #'Refactoring-Tests-Core'
}

{ #category : #'failure tests' }
RBRenameTemporaryTest >> testBadInterval [
	self
		shouldFail:
			(RBRenameArgumentOrTemporaryRefactoring
				renameTemporaryFrom: (14 to: 17)
				to: 'asdf'
				in: RBRefactoryTestDataApp
				selector: #testMethod).
	self
		shouldFail:
			(RBRenameArgumentOrTemporaryRefactoring
				renameTemporaryFrom: (17 to: 14)
				to: 'asdf'
				in: RBRefactoryTestDataApp
				selector: #testMethod).
	self
		shouldFail:
			(RBRenameArgumentOrTemporaryRefactoring
				renameTemporaryFrom: (19 to: 24)
				to: 'asdf'
				in: RBRefactoryTestDataApp
				selector: #testMethod)
]

{ #category : #'failure tests' }
RBRenameTemporaryTest >> testBadName [
	self
		shouldFail:
			(RBRenameArgumentOrTemporaryRefactoring
				renameTemporaryFrom: (15 to: 19)
				to: 'name'
				in: RBLintRuleTestData
				selector: #openEditor);
		shouldFail:
			(RBRenameArgumentOrTemporaryRefactoring
				renameTemporaryFrom: (15 to: 19)
				to: 'rules'
				in: RBLintRuleTestData
				selector: #openEditor);
		shouldFail:
			(RBRenameArgumentOrTemporaryRefactoring
				renameTemporaryFrom: (15 to: 19)
				to: 'DependentFields'
				in: RBLintRuleTestData
				selector: #openEditor);
		shouldFail:
			(RBRenameArgumentOrTemporaryRefactoring
				renameTemporaryFrom: (15 to: 19)
				to: 'a b'
				in: RBLintRuleTestData
				selector: #openEditor)
]

{ #category : #'failure tests' }
RBRenameTemporaryTest >> testModelBadName [
	| class |
	model := RBClassModelFactory rbNamespace new.
	class := model classNamed: #Object.
	class 
		compile: 'aMethod: temp1 ^[| temp2 | temp2 := [:temp3 | temp3 = 5] value: 5. temp2] value'
		classified: #(#accessing).
	self
		shouldFail: (RBRenameArgumentOrTemporaryRefactoring 
					renameTemporaryFrom: (20 to: 24)
					to: 'temp3'
					in: class
					selector: #aMethod:);
		shouldFail: (RBRenameArgumentOrTemporaryRefactoring 
					renameTemporaryFrom: (20 to: 24)
					to: 'temp1'
					in: class
					selector: #aMethod:)
]

{ #category : #tests }
RBRenameTemporaryTest >> testRenameArg [
	| refactoring |
	refactoring := RBRenameArgumentOrTemporaryRefactoring
		renameTemporaryFrom: (7 to: 13)
		to: 'asdf'
		in: RBLintRuleTestData
		selector: #name:.
	self executeRefactoring: refactoring.

	self assert: ((refactoring model classNamed: #RBLintRuleTestData) parseTreeFor: #name:) equals: (self parseMethod: 'name: asdf 
	name := asdf')
]

{ #category : #tests }
RBRenameTemporaryTest >> testRenameTemporary [
	| refactoring |
	refactoring := RBRenameArgumentOrTemporaryRefactoring
		renameTemporaryFrom: (15 to: 19)
		to: 'asdf'
		in: RBLintRuleTestData
		selector: #openEditor.
	self executeRefactoring: refactoring.

	self assert: ((refactoring model classNamed: #RBLintRuleTestData) parseTreeFor: #openEditor) equals: (self parseMethod: 'openEditor
								| asdf |
								asdf := self failedRules.
								asdf isEmpty ifTrue: [^self].
								asdf size == 1 ifTrue: [^asdf first viewResults]')
]
