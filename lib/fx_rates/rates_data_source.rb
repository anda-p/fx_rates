class RatesDataSource
    def rates
        raise NotImplementedError
    end

    def load_rates
        raise NotImplementedError
    end 
end 