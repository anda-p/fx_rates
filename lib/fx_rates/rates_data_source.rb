class RatesDataSource
    def rates
        raise NotImplementedError
    end

    def load_data
        raise NotImplementedError
    end 
end 