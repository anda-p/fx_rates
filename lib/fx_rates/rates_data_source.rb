class RatesDataSource
    def base_currency
        raise NotImplementedError
    end

    def rates
        raise NotImplementedError
    end

    def load_data
        raise NotImplementedError
    end 
end 