RSpec.describe Tapestry::Ready do
  let(:test_interface) do
    Class.new do
      include Tapestry::Ready

      def interface_action
        :interface_action
      end
    end
  end

  context 'providing ready validations' do
    it 'a ready validation can be specified as an attribute' do
      expect(test_interface).to respond_to :page_ready
    end

    it 'adds validations to a list' do
      expect { test_interface.page_ready { true } }.to change { test_interface.ready_validations.size }.by(1)
    end

    it 'provides ready validations from the all interfaces in defined order' do
      subclass = Class.new(test_interface)
      validation_1 = -> { true }
      validation_2 = -> { true }
      validation_3 = -> { true }
      validation_4 = -> { true }

      subclass.page_ready(&validation_1)
      test_interface.page_ready(&validation_2)

      subclass.page_ready(&validation_3)
      test_interface.page_ready(&validation_4)

      expect(subclass.ready_validations).to eq [validation_2, validation_4, validation_1, validation_3]
    end
  end

  context 'checking if the interface is ready' do
    let(:inherit_test_interface) { Class.new(test_interface) }

    it 'indicates that all ready validations have passed' do
      test_interface.page_ready { true }
      test_interface.page_ready { true }
      inherit_test_interface.page_ready { true }
      inherit_test_interface.page_ready { true }

      expect(inherit_test_interface.new).to be_ready
    end

    it 'indicates if any ready validation fails' do
      test_interface.page_ready { true }
      test_interface.page_ready { true }
      inherit_test_interface.page_ready { true }
      inherit_test_interface.page_ready { false }

      expect(inherit_test_interface.new).not_to be_ready
    end

    it 'indicates if any ready validation fails in an inheritance chain' do
      test_interface.page_ready { true }
      test_interface.page_ready { false }
      inherit_test_interface.page_ready { true }
      inherit_test_interface.page_ready { true }

      expect(inherit_test_interface.new).not_to be_ready
    end

    it 'sets an error message if a failing ready validation supplies one' do
      test_interface.page_ready { [true, 'will not fail'] }
      test_interface.page_ready { [false, 'will fail'] }
      inherit_test_interface.page_ready { [true, 'will not fail'] }
      inherit_test_interface.page_ready { [true, 'will not fail'] }

      instance = inherit_test_interface.new
      instance.ready?
      expect(instance.ready_error).to eq 'will fail'
    end
  end

  context 'execution based on ready status' do
    # it 'requires a block to be processed' do
    #  expect {
    #    test_interface.new.when_ready
    #  }.to raise_error Tapestry::Errors::NoBlockForWhenReady
    # end

    it 'yields to a provided block when all ready validations pass' do
      test_interface.page_ready { true }
      instance = test_interface.new

      expect(instance).to receive(:interface_action)

      instance.when_ready do |action|
        action.interface_action && true
      end
    end

    it 'indicates if any ready validation fails' do
      fake_page = spy

      test_interface.page_ready { true }
      test_interface.page_ready { false }

      expect do
        test_interface.new.when_ready { fake_page.test_action }
      end.to raise_error(Tapestry::Errors::PageNotValidatedError, /NO REASON PROVIDED/)

      expect(fake_page).not_to have_received(:test_action)
    end

    it 'indicates if any ready validation fails with a specific error message' do
      test_interface.page_ready { [false, 'reason provided'] }

      expect do
        test_interface.new.when_ready { puts 'testing' }
      end.to raise_error(Tapestry::Errors::PageNotValidatedError, /reason provided/)
    end

    it 'indicates failure immediately on the first validation failure' do
      validation_1 = spy(valid?: false)
      validation_2 = spy(valid?: false)

      test_interface.page_ready { validation_1.valid? }
      test_interface.page_ready { validation_2.valid? }

      expect do
        test_interface.new.when_ready { puts 'testing' }
      end.to raise_error Tapestry::Errors::PageNotValidatedError

      expect(validation_1).to have_received(:valid?).once
      expect(validation_2).not_to have_received(:valid?)
    end

    it 'executes validations only once for nested calls' do
      fake_page = spy
      validation_1 = spy(valid?: true)

      test_interface.page_ready { validation_1.valid? }
      instance = test_interface.new

      instance.when_ready do
        instance.when_ready do
          instance.when_ready do
            fake_page.test_action
          end
        end
      end

      expect(fake_page).to have_received(:test_action)
      expect(validation_1).to have_received(:valid?).once
    end

    it 'recognizes if a ready value is cached' do
      validation_1 = spy(valid?: true)
      test_interface.page_ready { validation_1.valid? }

      instance = test_interface.new
      instance.ready = true

      expect(instance).to be_ready
      expect(validation_1).not_to have_received(:valid?)
    end

    it 'resets the ready cache at the end of the execution block' do
      test_interface.page_ready { true }
      instance = test_interface.new

      expect(instance.ready).to be nil

      instance.when_ready do |i|
        expect(i.ready).to be true
      end

      expect(instance.ready).to be nil
    end
  end
end
